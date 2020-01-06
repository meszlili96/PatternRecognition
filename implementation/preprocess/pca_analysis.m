clear
load('../data/oils.mat')
samples = Data.samples;
countries = Data.countries;
country = Data.country;
values = Data.values;

var_num = size(values, 2);

% no scaling
%Xa.Data=values;
% mean-centering
Xa.Data=mncn(values);
% autoscaling
%Xa.Data=auto(values);
% Remove default mean-centering to investigate different pre-processing
[Xa.Ld,Xa.Sc,latent] = pca(Xa.Data, 'Centered',false);
Xa.scree=latent/sum(latent)*100;

font_size = 16;

figure('DefaultAxesFontSize', 14); hold on
N = 1;
while Xa.scree(N) > 0.1
    N = N + 1; 
end
plot(Xa.scree(1:N),'g<-','markerfacecolor','g')
plot(Xa.scree(1:N),'ro')
plot(Xa.scree(1:N),'bx')
xlabel('PC', 'FontSize', font_size)
ylabel('% variance explained by PC', 'FontSize', font_size)
title('Scree plot')

r=input('How many PCs?');
Xa.Sc=Xa.Sc(:,1:r);
Xa.Ld=Xa.Ld(:,1:r);
if r==1
    figure('DefaultAxesFontSize', 14); hold on
    bar(find(countries==1),Xa.Sc(countries==1),'b')
    bar(find(countries==2),Xa.Sc(countries==2),'r')
    bar(find(countries==3),Xa.Sc(countries==3),'g')
    bar(find(countries==4),Xa.Sc(countries==4),'m')
    xlabel('Oils', 'FontSize', font_size)
    ylabel('Score', 'FontSize', font_size)
    title('scores')
    
    figure('DefaultAxesFontSize', 14); hold on
    bar(Xa.Ld,'k')
    xlabel('Variables', 'FontSize', font_size)
    ylabel('Score', 'FontSize', font_size)
    set(gca,'Xtick',[1:var_num],'Xticklabel',Xa.Data)
    xticklabel_rotate
    title('loadings')
    
elseif r>1
    if r>2
        xy=input('Which PC on x-axis and which on y-axis? [x y]');
    else xy=[1 2];
    end
    figure('DefaultAxesFontSize', 14); hold on
    plot(Xa.Sc(countries==1,xy(1)),Xa.Sc(countries==1,xy(2)),'bx')
    plot(Xa.Sc(countries==2,xy(1)),Xa.Sc(countries==2,xy(2)),'ro')
    plot(Xa.Sc(countries==3,xy(1)),Xa.Sc(countries==3,xy(2)),'g<','MarkerFaceColor','g')
    plot(Xa.Sc(countries==4,xy(1)),Xa.Sc(countries==4,xy(2)),'m<')
    eval(['xlabel(''PC ' num2str(xy(1)) ' ( ' num2str(round(Xa.scree(xy(1)))) ' %)'')'])
    eval(['ylabel(''PC ' num2str(xy(2)) ' ( ' num2str(round(Xa.scree(xy(2)))) ' %)'')'])
    Ld=10*Xa.Ld;
    %quiver(zeros(10,1),zeros(10,1),Ld(1:10,xy(1)),Ld(1:10,xy(2)),'k')
    text(Ld(:,xy(1)),Ld(:,xy(2)),char(Xa.Data'))
    title('Samples scores')
    legend(country)
    axis equal
end