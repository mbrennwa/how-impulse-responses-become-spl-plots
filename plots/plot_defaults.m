% new figure with specific defaults

function [figh, siz, fontsiz] = plot_defaults(siz, fontsiz)
	% fontsiz = 14;
	% siz = [8, 6];

	set (gcf, "DefaultFigurePaperUnits", "inches");
	set (0, "DefaultFigureUnits", "inches");
	set (0, "DefaultFigurePaperSize", siz);
	set (0, "DefaultFigurePaperPosition", [0, 0, siz(1), siz(2)]);
	set (0, "DefaultFigurePosition", [1, 1, siz(1), siz(2)]);
	set (0, "DefaultLineLineWidth", 1.5);
	set (0, "DefaultAxesLineWidth", 1.5);
	set (0, "DefaultAxesFontSize", fontsiz);
	figh = figure();
