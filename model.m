function y = model(Time,par,setup,y0)

    y=odemodel(par,...
        setup.nNodes,... #number of nodes
        setup.H,... #human population
        setup.Nf,...#fish population
        setup.Ns,...#snail population
        setup.Cf,...#caught fish quota
        setup.M,... #fish market matrix
        setup.W,... #hydrological connectivity
        setup.W2,...#bi-directional hydrological connectivity
        Time,...    
        y0);
        
    %%% ODE PART
    
    function y = odemodel(par,nNodes,H,Nf,Ns,Cf,M,W,W2,tspan,y0)

        [~,y]=ode45(@eqs,tspan,y0);
        
        function dy=eqs(t,y)

            dy=zeros(3*nNodes,1);

            temp1 = M*(y(3:3:end).*Nf.*Cf); 

            dy(1:3:end)=par.beta_FH*(temp1).*(1-y(1:3:end)) - par.mu_H*y(1:3:end);     

            dy(2:3:end)=par.beta_HS*(1-y(2:3:end)).*(H.*y(1:3:end)) +...
                par.mS*W*y(2:3:end) - ...
                (par.mS+par.mu_S)*y(2:3:end);  

            dy(3:3:end)=par.beta_SF*(1-y(3:3:end)).*Ns.*y(2:3:end) + ...
                par.mF*W2*y(3:3:end) - ...
                (par.mu_F+Cf+par.mF).*y(3:3:end); 
         
        end
    end

    
end