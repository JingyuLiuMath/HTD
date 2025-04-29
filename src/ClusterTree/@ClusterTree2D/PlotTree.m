function PlotTree(T)

% Note: Only support full tree.

arguments (Input)
    T ClusterTree2D;
end

for whatlevel = 0 : T.max_level_
    T.PlotLevelTree(whatlevel);
end

end