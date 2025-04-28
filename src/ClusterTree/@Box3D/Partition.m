function children = Partition(B)

arguments (Input)
    B Box3D;
end

arguments (Output)
    children (2, 2, 2) cell;
end

children = cell(2, 2);
I1_children = cell(1, 2);
[I1_children{1}, I1_children{2}] = B.I1_.Partition();
I2_children = cell(1, 2);
[I2_children{1}, I2_children{2}] = B.I2_.Partition();
I3_children = cell(1, 2);
[I3_children{1}, I3_children{2}] = B.I3_.Partition();

for it3 = 1 : 2
    for it2 = 1 : 2
        for it1 = 1 : 2
            children{it1, it2, it3} = Box3D(I1_children{it1}, I2_children{it2}, I3_children{it3});
        end
    end
end

end