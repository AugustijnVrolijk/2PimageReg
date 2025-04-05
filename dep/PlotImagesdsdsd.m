function runAll()
    imRef = getLargestImgRef([outputViews{:}]);
end

function warpedImgs = tFormImgBulk(imgs, tForms)
    arguments (Input)
        imgs (:, :) cell
        tForms (:, :) affinetform2d
    end

    if length(tForms) ~= length(imgs)
        error("different length images and tform arrays for plotImagestFormBulk");
    end
    
    outputViews = cell(nFiles, 1);
    warpedImgs = cell(nFiles, 1);

    for i = 1:nFiles
        outputViews{i} = affineOutputView(size(imgs{i}),tForms(i),"BoundsStyle","FollowOutput");
    end
    finalOutputView = getLargestImgRef([outputViews{:}]);
    
    for i = 1:nFiles
        warpedImgs{i} = imwarp(imgs{i}, tForms(i), "OutputView", finalOutputView);
    end
    
    plotImages(warpedImgs,imgNames);
end




function img = createColourImg(Images)
    nFiles = length(images);
    toplot = 1:nFiles; % sessions to plot
    
    colors = flipud(cmapL([0 0 1; 0 1 1; 0 1 0; 1 0.7 0; 1 0 0; 0.7 0 1], nFiles));
    if size(colors,1)==3
        colors = [1 0 0; 0 1 0; 0.3 0.3 1];
    elseif size(colors,1)==2
        colors = [1 0 0; 0 1 0.5];
    end

    % Plot image of unregistered overlayed recordings
    figure('Units','Normalized', 'Position', [0.1766 0.1407 0.4203 0.7074])
    subplot('Position', [0 0 1 1])
    img = CreateRGB2(images(toplot), colors(toplot,:));
end

function plotImages(images, ax)
    arguments (Input)
        images (:, 1) cell
        ax 
    end
    
    imagesc(ax, RGB)
    %{
    for i = 1:length(toplot)
        text(20, 20+i*17,fileNames(toplot(i)),'color',colors(toplot(i),:),...
            'fontweight','bold','fontsize',12)
    end
    hold on
    ------------ 
    NEED TO ADD FUNCTIONS TO PLOT PPs etc... maybe do
    seperately? pass plot object and contain PPs plotting there
    ------------
    for r = 1:nfiles
        for i = 1:PPs(r).Cnt
            plot(PPs(r).Con(i).x, PPs(r).Con(i).y, 'color', [colors(r,:) 0.2])
        end
    plot(PPs(r).P(1, :), PPs(r).P(2, :), '.', 'color', colors(r,:))
    end
    %}
end