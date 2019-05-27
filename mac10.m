function mac10(A)


% l'ensemble des valeurs propres dans un vecteur que l'on appelle lambda
lambda=eig(A) ; 
tol = 0.1 ;
[n,n]=size(A); 

%Initialisation
X1=[];
Y1=[]; 
X=[]
Y=[]
I= eye(n);%I matrice identite de dimension de A
epss=0.1; 
NB = 1000; 

% boucle pour toutes les valeurs propres

for ind = 1:length(lambda)
  % step 0
    lambda0= lambda(ind) 
    zcou = lambda0 + epss ; % Si lambda est reel => zcou reste reel
    k = 0 ; 
  % boucle pour determiner le premier point z1 appartenant a la courbe de niveau epsilon
    while (abs(min(svd(zcou*I - A)) - epss) > tol * epss)
        [U,S,V]= svd(zcou*I-A); %decomposition en valeurs singulieres pour déterminer le triplet singulier
        Umin=U(:,n);
        Vmin=V(:,n);
        Smin=S(n,n);
        zcou = zcou - ((Smin - epss)/real(Vmin'*Umin));  %equation 2.2 
        k = k + 1 ;  
    end
    z1 = zcou ;  
    hold on
    plot(real(z1), imag(z1))
    
    zj = z1 ; 
    flag=1;
    j=2; 
    
    while (flag==1 && j<NB)
      % Step prediction
        [U,S,V]=svd(zj*I-A);
        Umin = U(:,n);
        Vmin = V(:,n);
        Smin = S(n,n);
    
        gradient = (i*Vmin'*Umin)/(abs(Vmin'*Umin)) ; 
        Tk = 0.1;
        zj_t = zj+(Tk*gradient) ;  
      
%       Step correction Newton (une iteration)
        
        while (abs(min(svd(zj_t*I - A)) - epss) > tol * epss)
            [U,S,V]=svd(zj_t*I-A); 
            Umin=U(:,n);
            Vmin=V(:,n);
            Smin=S(n,n);
           
            zj_t = zj_t - ((Smin-epss)/(Umin'*Vmin)) ;  % equation 2.3 
        end
        zj=zj_t; 
 
        hold on
          x=real(zj);
          y=imag(zj);
        plot(x, y, 'x')
        
        if (abs(zj-z1)<0.001*z1)
            flag=0;
        end
        j=j+1;
        
    end % End for j 

end % fin boucle valeur propre 

disp ( "On peut dessiner")
 
end % fin programme

