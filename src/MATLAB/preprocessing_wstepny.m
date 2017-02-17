%  jesli potrzebne to ustalenie wsp�lnego zakresu danych ( do
%  peptyd�w-lipid�w tego nie potrzebowa�am ale do innych chyba robione to by�o
%  funkcj� matlabow� msresample )

% wczytanie danych mz-wartosci mz, mydata- macierz z widmami 
jpegFiles = dir('*.txt'); 
numfiles = length(jpegFiles);
dat =  importdata(jpegFiles(1).name);
mz=dat(:,1,:);
clearvars dat
i=1;
k=1;
mydata=zeros(size(mz,1),numfiles);
for k = 1:numfiles
  my(:,:,:) =  importdata(jpegFiles(k).name); 
  mydata(:,i)=my(:,2,:);
  i=1+i;
  k
  my=[];
end

% usuniecie linii bazowej
for i=1:numfiles
y_base(i,:) =msbackadj(mz,mydata(:,i));
end
y_base(y_base<0)=0;

% detekcja wartosci odstaj�cych ale nie wiem jak dok�adnie to by�o
% wczesniej


%uliniawianie
reference=nanmean(y_base,1);
alignedSpectrum=  adaptive_PAFFT(mz,y_base, reference, 0.7, 0.1);


%normalizacja do �redniej z TIC
widma=alignedSpectrum;
%1 i 2
for i=1:size(widma,2);
Tic1(i)=sum(widma(:,i));
Tic2(i)=Tic1(i)/size(widma,1);
end
%3
Tic3=nanmean(Tic2);
%4
Tic4=Tic2/Tic3;
%5
wid_norm=[];
for i=1:size(widma,2);
wid_norm(:,i)=widma(:,i)*1/Tic4(i);
end

% wyliczenie widma �redniego do GMM
meanspec=mean(wid_norm,2);

% GMM
opts.base = 0;      %if baseline correction
opts.draw = 1;      %if draw results
opts.mz_thr = 0.3;  %M/Z threshold for merging
opts.if_merge = 0;  %if merge components
opts.if_rem = 0;    %if remove additional components

mdl = ms_gmm_run(mz,meanspec,opts);
