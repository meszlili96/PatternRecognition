load('oils.mat')
samples = Data.samples;
countries = Data.countries;
country = Data.country;
values = Data.values;

var_num = size(values, 2);

disp('We will now analyze all oils together.')
disp('We mean center the data (press enter).');pause

Xa.Data=mncn(values);
[Xa.Ld,Xa.Sc,latent] = pca(Xa.Data);
Xa.scree=latent/sum(latent)*100;

scrs=get(0,'screensize');
figure('position',scrs);subplot(1,3,1);hold on
N = 1;
while Xa.scree(N) > 0.1
    N = N + 1; 
end
plot(Xa.scree(1:N),'g<-','markerfacecolor','g')
plot(Xa.scree(1:N),'ro')
plot(Xa.scree(1:N),'bx')
xlabel('PC')
ylabel('% variance explained by PC')
title('Scree plot')

r=input('How many PCs?');
Xa.Sc=Xa.Sc(:,1:r);
Xa.Ld=Xa.Ld(:,1:r);
if r==1
    subplot(1,3,2);hold on
    bar(find(countries==1),Xa.Sc(countries==1),'b')
    bar(find(countries==2),Xa.Sc(countries==2),'r')
    bar(find(countries==3),Xa.Sc(countries==3),'g')
    bar(find(countries==4),Xa.Sc(countries==4),'m')
    xlabel('Oils')
    ylabel('Score')
    title('scores')
    
    subplot(1,3,3);hold on
    bar(Xa.Ld,'k')
    xlabel('Variables')
    ylabel('Score')
    set(gca,'Xtick',[1:var_num],'Xticklabel',values)
    xticklabel_rotate
    title('loadings')
    
elseif r>1
    if r>2
        xy=input('Which PC on x-axis and which on y-axis? [x y]');
    else xy=[1 2];
    end
    subplot(1,3,2:3);hold on
    plot(Xa.Sc(countries==1,xy(1)),Xa.Sc(countries==1,xy(2)),'bx')
    plot(Xa.Sc(countries==2,xy(1)),Xa.Sc(countries==2,xy(2)),'ro')
    plot(Xa.Sc(countries==3,xy(1)),Xa.Sc(countries==3,xy(2)),'g<','MarkerFaceColor','g')
    plot(Xa.Sc(countries==4,xy(1)),Xa.Sc(countries==4,xy(2)),'m<')
    eval(['xlabel(''PC ' num2str(xy(1)) ' ( ' num2str(round(Xa.scree(xy(1)))) ' %)'')'])
    eval(['ylabel(''PC ' num2str(xy(2)) ' ( ' num2str(round(Xa.scree(xy(2)))) ' %)'')'])
    Ld=10*Xa.Ld;
    %quiver(zeros(10,1),zeros(10,1),Ld(1:10,xy(1)),Ld(1:10,xy(2)),'k')
    text(Ld(:,xy(1)),Ld(:,xy(2)),char(values'))
    title('Biplot')
    legend(country)
    axis equal
end