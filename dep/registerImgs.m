function imgTForms = registerImgs(inputImages, inputFixed)
    arguments (Input)
        inputImages (:, 1) cell
        inputFixed (1, 1) cell = {0}
    end
    arguments (Output)
        imgTForms (:, 1) affinetform2d
    end
    progressBar = waitbar(0, "Initialising ...");
    [fixedCell, movingCell] = resolveImagePairs(inputFixed, inputImages);
    %THERE IS A BUG HERE CHECK IN RESOLVEIMAGEPAIRS
    nImages = length(movingCell);

    imgTForms((nImages + 1), 1) = affinetform2d(); %one extra to include the fixed image, it will have a blank transform
    
    [optimizer, metric] = imregconfig("monomodal");   
    nLevels = 4;

    for i=1:nImages
        [fixedWarp, movingWarp] = warpPair(fixedCell{i}, movingCell{i}, imgTForms(i));

        progress = struct('iter',i,'total',nImages,'progressBar',progressBar);
        newTForm = PyramidRegisterPair(fixedWarp, movingWarp, metric, optimizer,progress,levels=nLevels,transform="affine");
        
        nextTForm = affinetform2d(imgTForms(i).A*newTForm.A);

        imgTForms(i+1) = nextTForm;
    end
    close(progressBar)

    function [fixedClean, movingClean] = resolveImagePairs(fixed, images)
        %{
        I want two arrays:
                    A:                                  B:
            FIXED : img1; img1; img1     -   FIXED : img1; img2; img3;
            MOVING: img2; img3; img4     -   MOVING: img2; img3; img4;
        
        Three scenarios:
            Fixed is not given - then we do option B
            Fixed is given - not duplicate in Images - option A
            Fixed is given - is duplicate in Images - option A
        %}
        if length(fixed) >= 2
            error("only one image can be selected as the 'pivot'");
        elseif isequal(fixed{1}, 0)
            nPairs = length(images) - 1; 
            fixedClean = cell(nPairs, 1);
            movingClean = cell(nPairs, 1);
            for j = 1:nPairs
                fixedClean{j} = images{j};
                movingClean{j} = images{j + 1};
            end
        else
            %THIS IS THE BUG; THE DUPLICATE IS NOT NECESSARILY Images{1} SO
            %NEED TO LOOP THROUGH AND CHECK
            if isequal(images{1}, fixed{:})
                images = images(2:end);
            end
            nPairs = length(images);
            fixedClean = cell(nPairs, 1);
            movingClean = cell(nPairs, 1);
            for j = 1:nPairs
                fixedClean{j} = fixed{:};
                movingClean{j} = images{j};
            end
        end
    end

    function [fixedWarp, movingWarp] = warpPair(fixed, moving, tForm)
        noChange = affinetform2d();
        fixedView = affineOutputView(size(fixed),noChange,"BoundsStyle","FollowOutput");
        movingView = affineOutputView(size(moving),tForm,"BoundsStyle","FollowOutput");
        finalOutputView = getLargestImgRef([fixedView, movingView]);
        fixedWarp = imwarp(fixed, noChange, "OutputView", finalOutputView);
        movingWarp = imwarp(moving, tForm, "OutputView", finalOutputView);     
    end

    function finalImgRef = getLargestImgRef(ImgRefs)
        %first retrieve the world limit property into a 2*n matirx, then
        %reshape to an array of 1*2n. 
        XWorldLimitsArray = reshape(vertcat(ImgRefs.XWorldLimits), 1, []);
        YWorldLimitsArray = reshape(vertcat(ImgRefs.YWorldLimits), 1, []);
        %retrieve the range in coords to find the smallest and largest coord
        %needed to fit everything, round it to remove small fraction errors
        [xWorldmin, xWorldmax] = bounds(round(XWorldLimitsArray));
        [yWorldmin, yWorldmax] = bounds(round(YWorldLimitsArray));
        %calculate size
        xSize = xWorldmax - xWorldmin;
        ySize = yWorldmax - yWorldmin;
        finalImgRef = imref2d([ySize xSize], [xWorldmin, xWorldmax], [yWorldmin, yWorldmax]);
        if finalImgRef.PixelExtentInWorldX ~= 1 || finalImgRef.PixelExtentInWorldY ~= 1
            error('the calculated Pixel extent is wrong, this is a bug');
        end
    end

end