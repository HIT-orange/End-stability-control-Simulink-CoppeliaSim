% innfos3.m
% ���۶���ѧ�ṹ����
%�ȶ����˶�ѧ����
%ȫ��������
%syms d1 d2 d3;��ʱɾ��
% d=[       0.0792,   0.0792,    0.03350];%��δ���������������ʼ
d=[       0.0754,   0.0754,    0.034];%�����˼�
a=[        0,    0,     0];%/1000
alpha=[ pi/2, pi/2,     0];
offset=[pi,  -pi/2,     0];

%ʹ��offset �����˶�ѧ����
L(1)=Link('d',d(1),'a',a(1),'alpha',alpha(1),'offset',offset(1)); 
L(2)=Link('d',d(2),'a',a(2),'alpha',alpha(2),'offset',offset(2));
L(3)=Link('d',d(3),'a',a(3),'alpha',alpha(3));

du=pi/180;
ra=180/pi;
%����ؽڷ�Χ
L(1).qlim =[-170, 170]*du;
L(2).qlim =[-170, -170]*du;%-10,130
L(3).qlim =[-170,-170]*du;%-140,0

bot=SerialLink(L,'name','innfosĩ����̬�ȶ�');
%bot.tool= transl(0, 0, tool)

% ����ѧ���������ݿ���Դ��SolidWorks����Ҫע�ⵥλ��ע�⣡m3��ʾĩ�˸���
syms I1xx I1yy  I1zz  I1xy  I1xz  I1yz  xc1  yc1  zc1  m1 ;
syms I2xx  I2yy  I2zz  I2xy  I2xz  I2yz  xc2   yc2  zc2  m2 ;
syms I3xx  I3yy  I3zz  I3xy  I3xz  I3yz  xc3  yc3  zc3  m3 data;
data=[
    %     Ixx��    Iyy,      Izz,        Ixy,        Ixz,        Iyz,          xc,         yc,        zc,       m      xp    yp    zp

       2152.449,  2095.640,  206.630,      0,          0,    -71.267,          0,          0,      75.4,    0.381,    0,   0,    0;
       2096.966,  2153.820,  206.676,      0,     71.943,          0,          0,          0,      75.4,    0.381,    0,   0,    0;
       4625.752,  4625.752,  110.689,      0,          0,          0,          0,          0,     120.4,    0.290,    0,   0,    86;
    ];
%% data=[
    %     Ixx��    Iyy,      Izz,        Ixy,        Ixz,        Iyz,         xc,         yc,        zc,       m
%       2152.449,  2095.640,  206.630,      0,          0,    -71.267,          0,     -2.450,      70.421,     0.381;
%       2096.966,  2153.820,  206.676,      0,     71.943,          0,      2.474,          0,      70.445,     0.381;
%       4625.752,  4625.752,  110.689,      0,          0,          0,          0,          0,     120.399,     0.290;
%    ];

data(:,1:6)=data(:,1:6)./1000000;
data(:,7:9)=data(:,7:9)./1000;
data(:,11:13)=data(:,11:13)./1000;
% �涯��ѧ��⺯��
% ���� ��е�����ƣ�λ�á��ٶȡ����ٶȾ���
% ����ؽ�Ť��
% ��MDH_Dy.m�ĸĽ��棬ʹ��offset
% �Ľ�������ֱ��ʹ�û����˵�ĳЩ����


%% ������ֱ���   
% ����ؽڽǶ�
    syms q1 q2 q3;
    syms dq1 dq2 dq3;
    syms ddq1 ddq2 ddq3;
   % [q1,q2,q3]=deal(Q(1),Q(2),Q(3));
   % [dq1,dq2,dq3]=deal(DQ(1),DQ(2),DQ(3));
   %[ddq1,ddq2,ddq3]=deal(DDQ(1),DDQ(2),DDQ(3));
   %%����D��T
% ��������ͱ���
syms Dij Dijj Dijk Dijk
    Dij=cell(3,3);
    Dijj=cell(3,3);
    Dijk=cell(5,3);
    Di=cell(5,1);
    q=[q1;q2;q3];
    dq=[dq1;dq2;dq3];
    ddq=[ddq1;ddq2;ddq3];
    dqdq=[dq1*dq2;dq1*dq3;
        dq2*dq3];
    %% ����α��������
    J_cell=cell(3,1);
    %Ixx��Iyy,Izz,  Ixy,Ixz,Iyz,  xc,yc,zc,m
    %���ȵ�λmm����������kg*mm��
   % data=[
    %     Ixx��    Iyy,      Izz,        Ixy,        Ixz,        Iyz,         xc,         yc,        zc,       m
 %      47.316,  51.601,   77.113,     -0.003,     -2.549,     -0.016,     -0.598,      0.016,   -23.413,   0.076;
 %      62.746, 651.130,  704.486,     29.632,     -0.001,     -0.003,    104.910,    -31.512,     0.001,   0.151;
 %       6.264, 224.674,  228.590,    -14.345,     -0.006,          0,     69.863,      8.061,     0.015,   0.065;
       
 %   ];

%     data=[
%         22.134, 30.762, 24.755, -2.241, -0.00, 0, -2.546, -21.352, 0.302, -2.948;
%         85.387, 822.001, 893.708, 48.758, 0, 0, 102.348, -34.530, 0, 0.223;
%         5.440, 281.010, 283.608,  -17.983, 0, 0, 68.088, 7.699, 0, 0.084;
%        
%         ];
    for i=1:3
        Ixx=data(i,1);Iyy=data(i,2);Izz=data(i,3);
        Ixy=data(i,4);Ixz=data(i,5);Iyz=data(i,6);
        xc=data(i,7);yc=data(i,8);zc=data(i,9);
        m=data(i,10);

        J=[(-Ixx+Iyy+Izz)/2,Ixy,Ixz,m*xc;
            Ixy,(Ixx-Iyy+Izz)/2,Iyz,m*yc;
            Ixz,Iyz,(Ixx+Iyy-Izz)/2,m*zc;
            m*xc,m*yc,m*zc,m];

        J_cell{i}=J;   
    end
    %% �˶�ѧ����ת�ƾ���
     global T_cell;
    T_cell=cell(3,1);
 

    for i=1:3
        T_cell{i}=[ cos(q(i)+offset(i)), -sin(q(i)+offset(i))*cos(alpha(i)), sin(q(i)+offset(i))*sin(alpha(i)), a(i)*cos(q(i)+offset(i));
 sin(q(i)+offset(1)),  cos(q(i)+offset(i))*cos(alpha(i)), -cos(q(i)+offset(i))*sin(alpha(i)),   a(i)*sin(q(i)+offset(i));
      0,        sin(alpha(i)), cos(alpha(i)), d(i);
     0,        0, 0,  1];
% T_cell{2}=[ cos(q2 - pi/2), 0,   sin(q2 - pi/2),  0;
% sin(q2 - pi/2),            0,  -cos(q2 - pi/2),  0;
 %             0,                  1, 0, d(2);
 %            0,                  0, 0,  1];
 %T_cell{3}=[ cos(q3), -sin(q3), 0,  0;
 %sin(q3),  cos(q3), 0,  0;
 %      0,        0, 1, d(3);
 %    0,        0, 0,  1];
 
    end
    

    %% Dij
    %��
    for i=1:3
        %��
        for j=1:3
            p=max(i,j);
            %�ۼ�
            D=0;
            for pp=p:3          
                Upj=Uij(pp,j);
                Upi=Uij(pp,i);
                D=D+trace(Upj*J_cell{pp}*Upi.');           
            end
            Dij{i,j}=simplify(D);
        end
    end
    %% Dijj
    for i=1:3
        for j=1:3
            p=max(i,j);
            %�ۼ�
            D=0;
            for pp=p:3          
                Upjj=Uijk(pp,j,j);
                Upi=Uij(pp,i);
                D=D+trace(Upjj*J_cell{pp}*Upi.');           
            end
            Dijj{i,j}=simplify(D);
        end
    end
    %% Dijk
    %��Ǳ��j��k��forѭ����¼��̫���㣬����ֱ��д����
    dijk_j=[1,1,2];
    dijk_k=[2,3,3];
    %��
    for i=1:3
        %��ѭ��
        for s=1:3
            %���ڱ��ѭ��
            j=dijk_j(1,s);
            k=dijk_k(1,s);
            %p=max(i,j,k)
            p=max(i,j);
            p=max(p,k);
            %�ۼ�
            D=0;
            for pp=p:3
              Upjk=Uijk(pp,j,k);
              Upi=Uij(pp,i);
              D=D+trace(Upjk*J_cell{pp}*Upi.');  
            end
            Dijk{i,s}=simplify(D);
        end
    end
    %% Di
g=[0,-9.81,0,0];%���л�е������������ϵ����һ�£�����Ϊ��

    for i=1:3
        D=0;
        %�ۼ�
        for p=i:3
           m_p=data(p,10);
           %λ�úͼ��ٶȶ������
           
           Upi=Uij(p,i);
           %λ������p����ϵ�� r��1��4���о���
           r_cp=[data(p,11);data(p,12);data(p,13);1];
           D=D+m_p*g*Upi*r_cp; %ǰ�����ؽ����ض�Ϊ0��Up2ֻ�ں�����Ϊ0��gֻ�ڵ����в�Ϊ0
           
        end
        Di{i}=-simplify(D);
    end
     %% ���㶯��ѧ���̣����ӣ�
     T=cell(3,1);
     for i=1:3
    T{i}= [Dij{i,1},Dij{i,2},Dij{i,3}]*ddq + [Dijj{i,1},Dijj{i,2},Dijj{i,3}]*(dq.^2) + 2*[Dijk{i,1},Dijk{i,2},Dijk{i,3}]*dqdq +Di{i};
    T{i}=vpa(simplify( T{i}),3);%�򻯱�Ϊ����
     end
    %%
% �����������ն���ѧ����Uij
% ��MDH_Dy��ʹ��
function [ U ] = Uij( i,j )
    global T_cell;
%��ת����ԽǶ���
   Q=[0, -1, 0, 0;
      1,  0, 0, 0;
      0,  0, 0, 0;
      0,  0, 0, 0];
   U=1;
   for kk=1:j-1
        U=U*T_cell{kk};
    end
    
    U=U*Q;
    
    for kk=j:i
        U=U*T_cell{kk};
    end
end
% �����������ն���ѧ����Uij
% ��MDH_Dy��ʹ��
%%
function [ U ] = Uijk(  i,j,k )
   global T_cell;
   Q=[0, -1, 0, 0;
       1,  0, 0, 0;
       0,  0, 0, 0;
       0,  0, 0, 0];
   U=1;
   for p=1:j-1
        U=U*T_cell{p};
   end
    
   U=U*Q;
   %for���ж���ѭ�� 
   for p=j:k-1
        U=U*T_cell{p};
   end
    
   U=U*Q;
    
   for p=k:i
        U=U*T_cell{p};
   end

end
