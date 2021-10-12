drop database if exists dbc45;
create database dbc45;
use dbc45;

create table tblData(
    Patient varchar(10),
    Demam varchar(10),
    Sakitkepala varchar(10),
    Nyeri varchar(10),
    Lemas varchar(10),
    Kelelahan varchar(10),
    Hidung_tersumbat varchar(10),
    Bersin varchar(10),
    Sakit_tenggorokan varchar(10),
    Sulit_bernafas varchar(10),
    Diagnosa varchar(10)
);
INSERT INTO tblData VALUES
('P1', 'Tidak','Ringan', 'Tidak','Tidak','Tidak','Ringan','Parah','Parah','Ringan','Demam'),
('P2', 'Parah','Parah','Parah','Parah','Parah','Tidak','Tidak','Parah','Parah','Flu'),
('P3', 'Parah','Parah','Ringan','Parah','Parah','Parah','Tidak','Parah','Parah','Flu'),
('P4', 'Tidak','Tidak','Tidak','Ringan','Tidak','Parah','Tidak','Ringan','Ringan','Demam'),
('P5', 'Parah','Parah','Ringan','Parah','Parah','Parah','Tidak','Parah','Parah','Flu'),
('P6', 'Tidak','Tidak','Tidak','Ringan','Tidak','Parah','Parah','Parah','Tidak','Demam'),
('P7', 'Parah','Parah','Parah','Parah','Parah','Tidak','Tidak','Tidak','Parah','Flu'),
('P8', 'Tidak','Tidak', 'Tidak','Tidak','Tidak','Parah','Parah','Tidak','Ringan','Demam'),
('P9', 'Tidak','Ringan','Ringan','Tidak','Tidak','Parah','Parah','Parah','Parah','Demam'),
('P10', 'Parah','Parah', 'Parah','Ringan','Ringan','Tidak','Parah','Tidak','Parah','Flu'),
('P11', 'Tidak','Tidak', 'Tidak','Ringan','Tidak','Parah','Ringan','Parah','Tidak','Demam'),
('P12', 'Parah','Ringan','Parah','Ringan','Parah','Tidak','Parah','Tidak','Ringan','Flu'),
('P13', 'Tidak', 'Tidak', 'Ringan','Ringan','Tidak','Parah','Parah','Parah','Tidak','Demam'),
('P14', 'Parah', 'Parah', 'Parah','Parah','Ringan','Tidak','Parah','Parah','Parah','Flu'),
('P15', 'Ringan', 'Tidak', 'Tidak','Ringan','Tidak','Parah','Tidak','Parah','Ringan','Demam'),
('P16', 'Tidak', 'Tidak', 'Tidak','Tidak','Tidak','Parah','Parah','Parah','Parah','Demam'),
('P17', 'Parah', 'Ringan', 'Parah','Ringan','Ringan','Tidak','Tidak','Tidak','Parah','Flu');

select * from tblData;

create table tblCount(
    Iteration int,
    Attribute varchar(25),
    Information varchar(25),
    Datacount int,
    Diagnosa_flu int,
    Diagnosa_Demam int,
    Enthropy Decimal(10,4),
    Gain Decimal(10,4)
);

create table tblStep(
    Iteration int,
    Attribute varchar(25),
    Information varchar(25),
    Gain Decimal(10,4)
);

create table tblColumn(
    Iteration int,
    Patient varchar(10),
    Demam varchar(10),
    Sakitkepala varchar(10),
    Nyeri varchar(10),
    Lemas varchar(10),
    Kelelahan varchar(10),
    Hidung_tersumbat varchar(10),
    Bersin varchar(10),
    Sakit_tenggorokan varchar(10),
    Sulit_bernafas varchar(10)
);

create table tblGain(
    Iteration int,
    Attribute varchar(25),
    Gain Decimal(8,4)
);

Delimiter $$
Create procedure spEliminasi(pLoop int)
Begin 
    
    Declare vStepIteration, vStepLoop, vStepDatacount int default 0;
    Declare vStepAttribute varchar(25);

        Declare vColumnloop, vColumnDatacount, vColumniteration int default 0;
        Declare vColumnPatient, vColumnDemam, vColumnSakitkepala, vColumnNyeri, vColumnLemas, vColumnKelelahan, vColumnHidungtersumbat, vColumnBersin, vColumnSakittenggorokan, vColumnSulitbernafas, vColumnDiagnosa varchar(50);
    
    Declare cStep cursor for select Iteration, Attribute, Information from tblStep;
        Declare cColumn cursor for select * from tblColumn;
    Select count(*) into vStepDatacount from tblStep;
        Select count(*) into vColumnDatacount from tblColumn 
        where Iteration = pLoop;

        Open cColumn;
            While vColumnloop < vColumnDatacount DO 
                Fetch cColumn into vColumniteration, vColumnPatient, vColumnDemam, vColumnSakitkepala, vColumnNyeri, vColumnLemas, vColumnKelelahan, vColumnHidungtersumbat, vColumnBersin, vColumnsakittenggorokan, vColumnSulitbernafas;
                set vStepLoop = 0;
                open cStep;

                    While vStepLoop < vStepDatacount DO 
                        Fetch cStep into vStepIteration, vStepAttribute, vColumnDiagnosa;

                        If vStepAttribute = 'Demam' Then 
                            If vColumnDemam <> vColumnDiagnosa Then 
                                Delete from tblColumn where Iteration = pLoop
                                And Patient = vColumnPatient;
                            End if;
                        
                        Elseif vStepAttribute = 'Sakitkepala' Then 
                            If vColumnSakitkepala <> vColumnDiagnosa Then 
                                Delete from tblColumn where Iteration = pLoop
                                And Patient = vColumnPatient;
                            End if;

                        Elseif vStepAttribute = 'Nyeri' Then 
                            If vColumnNyeri <> vColumnDiagnosa Then 
                                Delete from tblColumn where Iteration = pLoop
                                And Patient = vColumnPatient;
                            End if;

                        Elseif vStepAttribute = 'Lemas' Then 
                            If vColumnNyeri <> vColumnDiagnosa Then 
                                Delete from tblColumn where Iteration = pLoop
                                And Patient = vColumnPatient;
                            End if;

                        Elseif vStepAttribute = 'Kelelahan' Then 
                            If vColumnKelelahan <> vColumnDiagnosa Then 
                                Delete from tblColumn where Iteration = pLoop
                                And Patient = vColumnPatient;
                            End if;

                        Elseif vStepAttribute = 'Hidungtersumbat' Then 
                            If vColumnHidungtersumbat <> vColumnDiagnosa Then
                                Delete from tblColumn where Iteration = pLoop
                                And Patient = vColumnPatient;
                            End if;

                        Elseif vStepAttribute = 'Bersin' Then 
                            If vColumnBersin<> vColumnDiagnosa Then 
                                Delete from tblColumn where Iteration = pLoop
                                And Patient = vColumnPatient;
                            End if;

                        Elseif vStepAttribute = 'Sakitenggorokan' Then 
                            If vColumnSakittenggorokan <> vColumnDiagnosa Then 
                                Delete from tblColumn where Iteration = pLoop
                                And Patient = vColumnPatient;
                            End if;

                        Elseif vStepAttribute = 'Sulitbernafas' Then 
                            If vColumnSulitbernafas <> vColumnDiagnosa Then 
                                Delete from tblColumn where Iteration = pLoop
                                And Patient = vColumnPatient;
                            End if;

                        End if;
                    Set vStepLoop = vStepLoop + 1;
                    End while;
                Close cStep;

                Set vColumnloop = vColumnloop + 1;
            End while;
        Close cColumn;
End $$
Delimiter ;



Delimiter $$
Create Procedure spEnthropy(pLoop int)

Begin 
    Select pLoop as 'Loop';
    Insert into tblColumn
    Select pLoop, Patient, Demam, Sakitkepala, Nyeri, Lemas, Kelelahan, Hidung_tersumbat, Bersin, Sakit_tenggorokan, Sulit_bernafas
    from tblData;

End $$
Delimiter ;

Delimiter $$
Create procedure spCountDia(pLoop int)
Begin 
        Declare vAttribute varchar(20) Default '';
        Declare vDiaDemam, vDiaFlu int Default 0;

        Declare vStepIteration, vStepDatacount, vStepLoop int default 0;
        Declare vStepAttribute, vInformation varchar(20);

        Declare cStep cursor for select Attribute, Information from tblStep;
        Select count(*) into vStepDatacount from tblStep;

        If pLoop = 1 Then 
            
            Set vAttribute = '';
            Select count(*) into vDiaFlu from tblColumn where Diagnosa = 'Flu';
            Select count(*) into vDiaDemam from tblColumn where Diagnosa = 'Demam';

            Insert into tblCount(Iteration,Attribute,Datacount,Diagnosa_flu,Diagnosa_Demam) 
            Values(pLoop,vAttribute,vDiaFlu+vDiaDemam, vDiaFlu, vDiaDemam);
        End if;

        Insert into tblCount(Information, Iteration,Attribute,Datacount,Diagnosa_flu,Diagnosa_Demam)
        Select distinct(A.Demam), pLoop, 'Demam', (select count(*) from tblColumn where Iteration = pLoop and Demam =A.Demam),(select count(*) from tblColumn where Iteration = pLoop and Demam = A.Demam and Diagnosa = 'Demam'), (select count(*) from tblColumn where Iteration = pLoop and Demam = A.Demam And Diagnosa = 'Flu')
        from tblColumn As A where Iteration = pLoop;

        Select distinct(A.Sakitkepala), pLoop, 'Sakitkepala', (select count(*) from tblColumn where Iteration = pLoop and Sakitkepala =A.Sakitkepala),(select count(*) from tblColumn where Iteration = pLoop and Sakitkepala = A.Sakitkepala and Diagnosa = 'Demam'), (select count(*) from tblColumn where Iteration = pLoop and Sakitkepala = A.Sakitkepala And Diagnosa = 'Flu')
        from tblColumn As A where Iteration = pLoop;

        Select distinct(A.Nyeri), pLoop, 'Nyeri', (select count(*) from tblColumn where Iteration = pLoop and Nyeri =A.Nyeri),(select count(*) from tblColumn where Iteration = pLoop and Nyeri = A.Nyeri and Diagnosa = 'Demam'), (select count(*) from tblColumn where Iteration = pLoop and Nyeri = A.Nyeri And Diagnosa = 'Flu')
        from tblColumn As A where Iteration = pLoop;

        Select distinct(A.Lemas), pLoop, 'Lemas', (select count(*) from tblColumn where Iteration = pLoop and Lemas =A.Lemas),(select count(*) from tblColumn where Iteration = pLoop and Lemas = A.Lemas and Diagnosa = 'Demam'), (select count(*) from tblColumn where Iteration = pLoop and Lemas = A.Lemas And Diagnosa = 'Flu')
        from tblColumn As A where Iteration = pLoop;

        Select distinct(A.Kelelahan), pLoop, 'Kelelahan', (select count(*) from tblColumn where Iteration = pLoop and Kelelahan =A.Kelelahan),(select count(*) from tblColumn where Iteration = pLoop and Kelelahan = A.Kelelahan and Diagnosa = 'Demam'), (select count(*) from tblColumn where Iteration = pLoop and Kelelahan = A.Kelelahan And Diagnosa = 'Flu')
        from tblColumn As A where Iteration = pLoop;

        Select distinct(A.Hidung_tersumbat), pLoop, 'Hidung_tersumbat', (select count(*) from tblColumn where Iteration = pLoop and Hidung_tersumbat =A.Hidung_tersumbat),(select count(*) from tblColumn where Iteration = pLoop and Hidung_tersumbat = A.Hidung_tersumbat and Diagnosa = 'Demam'), (select count(*) from tblColumn where Iteration = pLoop and Hidung_tersumbat = A.Hidung_tersumbat And Diagnosa = 'Flu')
        from tblColumn As A where Iteration = pLoop;

        Select distinct(A.Bersin), pLoop, 'Bersin', (select count(*) from tblColumn where Iteration = pLoop and Bersin =A.Bersin),(select count(*) from tblColumn where Iteration = pLoop and Bersin = A.Bersin and Diagnosa = 'Demam'), (select count(*) from tblColumn where Iteration = pLoop and Bersin = A.Bersin And Diagnosa = 'Flu')
        from tblColumn As A where Iteration = pLoop;

        Select distinct(A.Sakit_tenggorokan), pLoop, 'Sakit_tenggorokan', (select count(*) from tblColumn where Iteration = pLoop and Sakit_tenggorokan =A.Sakit_tenggorokan),(select count(*) from tblColumn where Iteration = pLoop and Sakit_tenggorokan = A.Sakit_tenggorokan and Diagnosa = 'Demam'), (select count(*) from tblColumn where Iteration = pLoop and Sakit_tenggorokan = A.Sakit_tenggorokan And Diagnosa = 'Flu')
        from tblColumn As A where Iteration = pLoop;

        Select distinct(A.Sulit_bernafas), pLoop, 'Demam', (select count(*) from tblColumn where Iteration = pLoop and Sulit_bernafas =A.Sulit_bernafas),(select count(*) from tblColumn where Iteration = pLoop and Sulit_bernafas = A.Sulit_bernafas and Diagnosa = 'Demam'), (select count(*) from tblColumn where Iteration = pLoop and Sulit_bernafas = A.Sulit_bernafas And Diagnosa = 'Flu')
        from tblColumn As A where Iteration = pLoop;

        Open cStep;

            While vStepLoop < vStepDatacount DO 
                Fetch cStep into vStepAttribute, vInformation;
                    Delete from tblCount 
                    where Iteration = pLoop And Attribute = vStepAttribute;
                Set vStepLoop = vStepLoop + 1;
            End while;
        
        Close cStep;

End $$
Delimiter ;


Delimiter $$
Create procedure spGain(pLoop int)
Begin 
    Declare vEnthropy Decimal (10,4);
    Declare vDatacount, vGainsum int Default 0;

    Select datacount into vDatacount from tblCount 
    where Iteration = pLoop ;
    Select enthropy into vEnthropy from tblCount 
    where Iteration = pLoop ;

    Insert into tblGain(Iteration, Attribute, Gain)
    Select pLoop, Attribute, 
            Round(Abs(vEnthropy - Sum((datacount/vDatacount)*enthropy)),4) as Enthropy
    from tblCount
    where Iteration = pLoop
    Group by Attribute;

    Update tblCount set Gain =(
        Select Gain from tblGain where Attribute = tblCount.Attribute And Iteration = pLoop
    ) where Iteration = pLoop;

    select max(Gain) into @tempGain from tblGain where Iteration = pLoop;
    select @tempGain as Gain;


Insert into tblStep(Iteration, Attribute,Information,Gain)
Select Iteration, Attribute,Information, Gain from tblCount
Where Gain=@tempGain And Iteration = pLoop
And Diagnosa_flu !=0 And Diagnosa_Demam != 0;

Select count(*) into vGainsum from tblStep 
where Iteration = pLoop;

if vGainsum < 1 Then 
    Insert into tblStep(Iteration, Attribute,Information,Gain)
    Select Iteration, Attribute, 'Finished', Gain from tblCount
    Where Gain=@tempGain and Iteration = pLoop
    Limit 1;
End if;

End $$
Delimiter ;


Delimiter $$
Create procedure spEnthropycount(pLoop int)
Begin 

        Update tblCount set Enthropy = (-(Diagnosa_flu/Datacount)* log2(Diagnosa_flu/Datacount)) + (-(Diagnosa_Demam/Datacount)* log2(Diagnosa_Demam/Datacount));
        Update tblCount set Enthropy = 0
        where Enthropy is NULL;

        call spGain(pLoop);

End $$
Delimiter ;

Delimiter $$
Create function spCheck (pLoop int)
Returns int
BEGIN
        Declare vLoopx, vLoopReturn int default 0;
        Set vLoopReturn =1;

        Select count(Information) into vLoopx from tblStep
        where Information = 'Finished';

        If vLoopx <> 0 THEN
            Set vLoopReturn = 2;
        End if;

    Return(vLoopReturn);
End $$
Delimiter ;


Delimiter $$
Create procedure spLoop()
Begin
        Declare vLoop, vStop;
        While vStop <= 1 DO 

                Call spEnthropy(vLoop);
                Call spEnthropycount(vLoop);
                Set vLoop = vLoop + 1;
                Set vStop = spCheck(vLoop);

            Select * from tblCount;
            Select * from tblStep;
            Select * from tblColumn;
            Select * from tblGain;
        End while;
End $$
Delimiter ;

call spLoop();
