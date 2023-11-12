function R=trans(Rn)
        R=[Rn(2) Rn(3)*Rn(1) Rn(1);
            -Rn(1) Rn(3)*Rn(2) Rn(2);
            0 -Rn(1)^2-Rn(2)^2 Rn(3)];
    end