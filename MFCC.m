function MFCCco = MFCC(au)
	M = 24;
	framelen = 256;
	inc = 80;
	fs = 8000;
	
	for k=1:24
    n=0:23;   
    dctcoef(k,:)=cos((2*n+1)*k*pi/(2*24));
	end   
	w=1+6*sin(pi*[1:24] ./24);  
	w=w/max(w);   
	
	%Mel�˲�������24 0.5 high end of highest filter
	bank=melbankm(M,framelen,fs,0,0.4,'t');
	bank=full(bank);
	bank=bank/max(bank(:));
	

	
	%Ԥ���ء���֡���Ӵ�
	au = filter([1 -0.9375],1,double(au));	
	%sound(au,8000);
	m = zeros(1,24);
	frames = enframe(au, framelen, inc); %�������Ե���
	for i=1:size(frames,1)
		f = frames(i,:);
		window = f'.*hamming(framelen);
		%��FFT�����ź�Ƶ��
		t = abs(fft(window));
		%����Ƶ��ƽ��
		t = t.^2;
		%Mel�˲����飬 ȡ������dct
		size(bank,2);
		c1=dctcoef*log(bank*t(1:size(bank,2)));   
		c2=c1.*w';
		m(i,:)=c2';   
		%c = dct(log(bank*t(1:size(bank,2))));
		%size(bank);
		%m(i,:) = c';
	end
	del = zeros(1,24);
	for i=3:size(frames,1)-2
		del(i-2,:) = (m(i-2,:).*(-2) + m(i-1,:).*(-1) + m(i+1,:).*(1) +  m(i,:).*(2))./sqrt(10);
	end
	
	size(m);
	MFCCco = m;
	size(del);
	%MFCCco = del;
	showplot = 1;
	if showplot == 0
		figure(5);
		imagesc(del);
	end



	

	% subplot(2,1,1) 
	% ccc_1=ccc(:,1);
	% plot(ccc_1);title('MFCC');ylabel('��ֵ');
	% [h,w]=size(ccc);
	% A=size(ccc);
	% subplot(212)    
	% plot([1,w],A);
	% xlabel('ά��');
	% ylabel('��ֵ');
	% title('ά�����ֵ�Ĺ�ϵ')


end