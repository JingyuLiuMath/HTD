function children = Partition(B)

arguments (Input)
    B Box2D;
end

arguments (Output)
    children (2, 2) cell;
end

children = cell(2, 2);
I1_children = cell(1, 2);
[I1_children{1}, I1_children{2}] = B.I1_.Partition();
I2_children = cell(1, 2);
[I2_children{1}, I2_children{2}] = B.I2_.Partition();

for it2 = 1 : 2
    for it1 = 1 : 2
        children{it1, it2} = Box2D(I1_children{it1}, I2_children{it2});
    end
end

end