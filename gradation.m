clear all;close all; % すべてのグローバル変数/ウィンドを消去
A=double(imread('kuma.jpg')); % sample2d.txtの読み込み
[ysize xsize]=size(A); %X の次元 d とサンプル数 n を取得
figure(1),imshow(A./255); %画像表示
X=reshape(A,1,[]); %一行になるように変形
[d,n]=size(X); % X の次元 d とサンプル数 n を取得
k=7;  %kの値設定

p=[];
R=randperm(n,k);   %1からnの整数からk個ランダムに選んだ行ベクトルR作成
for j=1:k
    p=[p,X(1,R(:,j))];  %プロトタイプをサンプルからk個ランダムに選ぶ
end
before=zeros(n,k);
while(1)
  u=zeros(n,k);   %n行k列の要素0の行列でuを初期化
  for i=1:n
      a=[];
      for j=1:k
          a=[a,(X(1,i)-p(:,j))'*(X(1,i)-p(:,j))]; %行列aに各プロトタイプとの距離を格納
      end
      [a,I]=sort(a,2);  %aを昇順にソート
      u(i,I(1))=1; %距離が最小のプロトタイプに対応するuの要素を1にする
  end
  for j=1:k
      if(u(:,j)==zeros(n,1))
      else
        p(:,j)=sum(u(:,j)'.*X(1,:),2)./sum(u(:,j)); %u(:,j)の要素がすべて0ではないときpの値更新
      end
  end
  if(before==u)   %beforeとuの値が一致したらwhile文を抜ける
     break;
  endif
  before=u;  %beforeにuを格納
end

Y=[];
for i=1:n
    for j=1:k
        if(u(i,j)==1)
          Y=[Y,p(j)];  %X(1,i)が属するプロトタイプの値をYに追加
        endif
    end
end

Y=reshape(Y,ysize,xsize); %元の画像のサイズに戻す
figure(2),imshow(Y./255); %k階調にした画像表示
