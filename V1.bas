$regfile = "M8def.dat"
$crystal = 8000000
'*****************************
Open "comb.4:9600,8,n,1" For Output As #1
Enable Interrupts
'*****************************
Config Watchdog = 2048
Start Watchdog
'*****************************
Config Adc = Single , Prescaler = Auto , Reference = Avcc
'*****************************
Config Timer1 = Timer , Prescale = 64
Enable Timer1
Start Timer1
On Timer1 Tick1
'*****************************
_in Alias Pind.5
Key_learn Alias Pinc.0
Led_learn Alias Portd.6
Relay Alias Portb.2

Config _in = Input
Config Key_learn = Input
Config Led_learn = Output
Config Relay = Output
'*****************************
Dim I As Word
Dim Ii As Word
Dim Adcc As Word

Dim Time_count As Word
Dim Rf_data(50) As Word
Dim Remote_id As String * 30
Dim Remote_data As String * 30
Dim Remote_code As Byte

Dim Remote_count(4) As Word

Dim Timee As Word

Dim Save_id As String * 30
Dim Eram_save_id As Eram String * 30
Save_id = Eram_save_id

Const Key_debounce = 300
'*****************************
Print #1 , "Hiiii" ; Save_id
Led_learn = 0
Relay = 0
Do
   Gosub Read_rf
   Reset Watchdog

   If Timee > 0 Then Relay = 1 Else Relay = 0
Loop
'*****************************
Tick1:
   Timer1 = 3106
   If Timee > 0 Then Decr Timee
Return
'*****************************
Read_rf:
   Remote_data = ""
   Remote_id = ""
   If _in = 1 Then
      'Do : Loop Until Key_learn = 0

      Time_count = 0
      Do : Incr Time_count : Waitus 5 : Loop Until _in = 1

      If Time_count > 800 And Time_count < 1300 Then
         Led_learn = 1
         Remote_id = ""
         I = 1
         Do
            If _in = 1 Then
               Time_count = 0
               Do : Incr Time_count : Waitus 5 : Loop Until _in = 0
               Rf_data(i) = Time_count
               Incr I
            End If
            Reset Watchdog
         Loop Until I > 24

         For I = 1 To 24
            If Rf_data(i) > 20 And Rf_data(i) < 60 Then
               Rf_data(i) = 0
               Remote_id = Remote_id + "0"
            Else
               If Rf_data(i) > 80 And Rf_data(i) < 160 Then
                  Rf_data(i) = 1
                  Remote_id = Remote_id + "1"
               Else
                  'Print #1 , I ; ")" ; Rf_data(i)
                  Remote_id = ""
                  Remote_data = ""
                  Return
               End If
            End If
         Next I

         Remote_data = Right(remote_id , 4)
         Remote_id = Left(remote_id , 20)
         'Print #1 , "ID=" ; Remote_id ; "  Data=" ; Remote_data

         Print #1 , "Data=" ; Remote_data ; "   ID=" ; Save_id       '; "  Flag=" ; Flag
         If Save_id = Remote_id Then                        'Check identity
            'Print #1 , "Data=" ; Remote_data

            'Adcc = Getadc(1)
            If Remote_data = "0001" Then Timee = 360
            If Remote_data = "0010" Then Timee = 0
            'If Remote_data = "0100" Then Timee = 50
            'If Remote_data = "1000" Then Timee = 120

         Else
            Remote_data = ""
         End If


         If Key_learn = 1 Then                              'Save new Remote
            Save_id = Remote_id
            Eram_save_id = Remote_id
            Waitms 10

            Print #1 , "Saved"
            Print #1 , "ID=" ; Remote_id ; "  Data=" ; Remote_data
            Do
               Reset Watchdog
               Waitms 10
            Loop Until Key_learn = 0
            Waitms 100
         End If
      End If
   End If
   Led_learn = 0
Return
'*****************************







'(
Dim Ops(300) As Word
Do

   If Key_learn = 1 Then
      Print #1 , "Start Record"

      For Ii = 1 To 250
         Do : Waitus 5 : Incr Ops(ii) : Loop Until _in = 1
         Incr Ii
         Do : Waitus 5 : Incr Ops(ii) : Loop Until _in = 0
      Next Ii

      For Ii = 1 To 250
         Print #1 , Ii ; ")" ; Ops(ii)
         Waitms 10
      Next Ii
   End If
Loop
')













