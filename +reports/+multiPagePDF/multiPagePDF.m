function multiPagePDF(figHandles, nameString)

% function multiPagePDF(figHandles,nameString)
%
% figHandles - a vector of figure handles, one figure per page
% nameString - a filename WITHOUT an extension

% where does matlab keep the cool files that we need?
coolFilesDir    = [matlabroot filesep 'toolbox' filesep 'matlab' filesep 'graphics' filesep 'private' filesep];

% where are we in directory structure right now?
goBackToMe      = pwd;

% make a variable to hold the "paper sizes" of each figure. Why: at present
% we can only make a PDF with each page having the same size. Thus, we'll
% set the PDF's page-size to the largest figure-size to prevent cropping
% any of the figures.
numFigs         = length(figHandles);
paperSizes      = zeros(numFigs, 2);

% loop over the figure-handles, fix-up the paper-units, sizes, etc.
for i = 1:length(figHandles)
    
    % grab the figure's position, we're going to use it to make sure
    % that the figure is rendered in the document as it appears on screen.
    temp = get(figHandles(i),'Position');
    
    % we're going to max-out the figure-width at 8.5 inches, so let's
    % modify the figure-size
    % make sure the units are "points" if they're not already, and set
    % the paper size and paper position variables to match the position
    % data.
    if ~strcmp(get(figHandles(i),'Units'),'points')
        set(figHandles(i),'PaperUnits','points',...
            'PaperSize',temp(3:4),...
            'PaperPosition',[0 0 temp(3:4)])
    else
        set(figHandles(i),'PaperUnits',get(figHandles(i),'Units'),...
            'PaperSize',temp(3:4),...
            'PaperPosition',[0 0 temp(3:4)])
    end
    
    % store the paper sizes
    paperSizes(i,:) = temp(3:4);
    
    % add the current figure to a post-script file, using color
    % post-script level 2 (it renders things a bit nicer).
    print(figHandles(i), '-dpsc2', '-append', [nameString '.ps'])
end

% move the post-script file to the folder where matlab keeps the
% GhostScript files (it's not in the path so we can't call those functions
% from just anywhere).
movefile([nameString '.ps'],[coolFilesDir filesep nameString '.ps']);

% change directories so we can call the GhostScript function.
cd(coolFilesDir)

% create a print-job with the appropriate properties for the task of
% converting a PS to a PDF (empirically determined).
pj.Handles                      = {figHandles(end)};
pj.FileName                     = [nameString '.ps'];
pj.DriverExt                    = 'pdf';
pj.DriverClass                  = 'GS';
pj.GhostDriver                  = 'pdfwrite';
pj.GhostName                    = ['.' filesep nameString '.pdf'];
pj.GhostDriver                  = 'pdfwrite';
pj.GhostImage                   = 1;
pj.GhostExtent                  = max(paperSizes);
pj.UseOriginalHGPrinting        = 1;
pj.PostScriptPreview            = 0;
pj.TiffPreview                  = 1;
pj.DebugMode                    = 0;
pj.DriverExport                 = 1;
pj.DriverColor                  = 1;
pj.DriverColorSetm              = 1;
pj.GhostTranslation             = [0 0];
pj.Validated                    = 1;
set(pj.Handles{1},'papersize', max(paperSizes));

% use GhostScript to convert the PS to a PDF, this will delete the PS file.
pj                          = ghostscript(pj);

% move the PDF back to whatever directory we called from originally
movefile([pj.GhostName],[goBackToMe filesep pj.GhostName]);

% change directories back to that original directory
cd(goBackToMe)
end