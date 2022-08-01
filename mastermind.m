clear; clc;
% MASTERMIND % 
% Aslı Alpsoy
%listing the colors
fprintf('color codes\n b:blue\n g:green\n r:red\n c:cyan\n m:magenta\n y:yellow\n');
w=0; b=0;
guess=zeros(1,4); %preallocation
%repetition allowance 
rep= input(['Color repetitions are not allowed as default. Enter "a" '...
        'if you want to allow repetitions: '],'s'); 
%codemaker sets up the colors
colors=["b" "g" "r" "c" "m" "y"]; 
n=numel(colors);
if isempty(rep)     %w/o repetitions
        set=colors(randperm((n),4));
    elseif rep=="a" %w/ repetitions   
        set=colors(randi(n,4,1));
end
fprintf('Ok, my set is ready, now start guessing in this format "crbg". Remember, you have only 8 trials :)\n ');
%codebreaker starts guessing
for j=1:8
guess= num2cell(input([ num2str(j) '. guess: '],'s')); %user input
d= ismember(set,guess); %compare colors without order
    if guess==set %correct answer
        disp('Yay! You guessed correctly.')
        break
    else
         b = sum(guess==set); %count blacks
         w = sum(d==1)-b; %counts whites               
disp(['you got ' num2str(b) ' (b)lacks and ' num2str(w) ' (w)hites.']); %feedback
    if j==8 && b ~=4
        disp(['Game over, correct answer was "' ,cell2mat(set) '".']);% game over message
    end
    end
end
  %kod hakkında notlar
  %    1- bu kodda beyaz ipuçlarının hesabını renklerin tekrar ettiği durumda
  %her case için doğru yaptıramadım.ismember foksiyonunu kullanıp bunun
  %sonucundan siyah sayısını çıkararak buldum. Problem şu gibi durumlarda ortaya
  %çıkıyor:
  % set "cbgc" olsun. tahmin "cbgg" olduğunda 3 siyah 1 beyaz hesaplıyorum
  % fakat beyaz sayısı 0 olmalı. Bu yanlış hesabın sebebi set'teki c lerin
  % ikisinin de tahminde yer alan 1. sıradaki c ile eşleşmesi ve ikisinin
  % de ortak olarak var değeri alması.
  %Bu algoritmayı henüz düzeltemedim. Bir fikrim ismember fonksiyonunu bir
  %de ismember(guess,set) şeklinde kullanmak ve sonra iki ismember
  %çıktısının kesişimini almak oldu. Diğer fikrim de ismember
  %fonksiyonundan ortak olan renklerin pozisyonlarını da almak oldu ama
  %buradan da ilerleyemedim. Nasıl bir çözüm bulabilirim?
  %    2- kullanıcı kaynaklı input hatalarını engelleyecek uyarılar henüz eklemedim 

  

    
    
    
    
 
    
