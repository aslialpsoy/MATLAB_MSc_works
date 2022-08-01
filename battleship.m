clear; clc;
% BATTLESHIP % 
% Aslı Alpsoy
N=10;%battleground size
board= zeros(N); %ships and shots are kept in board
boardisp= num2cell(zeros(N)); %to be displayed to the user
left= num2cell(1:N);
top= ["A" "B" "C" "D" "E" "F" "G" "H" "I" "J"];
Ac = [5 5 5 5 5]; % aircraft carrier
Bs = [4 4 4 4];   % battleship
Cr = [31 31 31];  % cruiser
Sb = [32 32 32];  % submarine
De = [2 2];       % destroyer   
fleet= [{Ac} {Bs} {Cr} {Sb} {De}];
% matlab sets up the battleground
 for i=1:5
     valid=0;
 while valid==0
    orientation = randi(2, 1, 1);  % 1 for vertical, 2 for horizontal
   
    if orientation==1  % vertical 
        r = randi(N-numel(cell2mat(fleet(i))),1,1);  %starting row
        c = randi(N,1,1);  %starting column            
         if sum(board(r:r+numel(cell2mat(fleet(i)))-1,c)~=0)==0 
             board(r:r+numel(cell2mat(fleet(i)))-1,c)= cell2mat(fleet(i))' ; 
             valid=1;
         end
    elseif orientation==2  %horizontal
        r = randi(N,1,1);  %starting row
        c = randi(N-numel(cell2mat(fleet(i))),1,1);  %starting column                   
         if sum(board(r,c:c+numel(cell2mat(fleet(i)))-1)~=0) == 0
             board(r,c:c+numel(cell2mat(fleet(i)))-1)= cell2mat(fleet(i));   
             valid=1;                 
         end  
     end
 end    
 end
    fprintf('Ok, my fleet is ready, now start shooting in the format "6 c" \n ');
    
for j=1:50
    %below part is to read the input for shot as a string, split it
    %into a 2-by-1 cell (row and column), convert the letter to the
    %corresponding column number and store row and column values as double. 
shot= upper(split(input([ num2str(j) '. shot: '],'s'),' ')); 
shot(1,1)=num2cell(str2double(shot(1,1)));
shot(2,1)=num2cell(find(top==cell2mat(shot(2,1))));
shot=cell2mat(shot);
    % displaying the miss and hit clues
if board(shot(1,1),shot(2,1))==0
    disp('Miss!')
    boardisp(shot(1,1),shot(2,1))= {"xx"};
    T=cell2table((horzcat(left',boardisp)),...
    'VariableNames',{' ' ,'A','B','C','D','E','F','G','H','I','J'});
    disp(T);
elseif board(shot(1,1),shot(2,1))~=0
    disp('Hit!')
    boardisp(shot(1,1),shot(2,1))= {"**"};
    T=cell2table((horzcat(left',boardisp)),...
    'VariableNames',{' ', 'A','B','C','D','E','F','G','H','I','J'});    
    disp(T);
end
    if j==50
        disp('You are out of shots, game over.');% game over message
    end
end
% kod hakkında notlar:
%   1- bu kodda birçok defa cell array kullandım. Bir gemi kümesi yaratabilmek
%ve içinden rastgele seçimler yapıp board a yazmak için 14.satırda fleet adında bir
%cell oluşturdum.tüm kodun uyumlu olabilmesi için de her iki board'u, bunlara
%yazılcak değerleri cell olarak tanımlamam gerekti.
%Seçimleri yapabildim, oyunun da fena olmadığını düşünüyorum
%fakat her şeyi cell şeklinde tanımlamam algoritmamı karmaşıklaştırmış
%olabilir. Kullanıcıya dönen, atışların tutulduğu board da bu nedenle pek
%user friendly değil. Cell yaratmadan gemileri nasıl yerleştirebilirdim?
%   2- kullanıcıya dönen board'da sütun adlarının harflerle belirtilebilmesi
%için concatenate fonksiyonları kullanamadım, bu nedenle de çıktıyı table şeklinde
%verdim. Bir nebze anlaşılır oldu fakat yine de atış yapılan
%sütunlardaki tırnak işaretlerini kaldıramadım.
%   3- kullanıcı kaynaklı input hatalarını engelleyecek uyarılar henüz eklemedim 
