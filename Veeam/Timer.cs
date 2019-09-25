using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;
using System.ComponentModel;
using System.Threading;

namespace TimeToKill
{
    class Program
    {
        public static Timer timer1;
  
        static int Main(string[] args)
        {
            int num = 0;
            int j = 2000; //раз в две секунды.
            /*  if (args.Length < 3 || args.Length>3)
              {
                  System.Console.WriteLine("Вы ввели неправильное кол-во аргументов!");
                  return 1;
              }
             
            j = Convert.ToInt32(args[2]) * 1000;
                str = args[0];
                min = Convert.ToInt32(args[1]);
                 */
                Console.WriteLine("Ожидание процесса!");
                timer1 = new Timer(MyMethod, num, 0, j);
                Console.ReadLine();
                return 0;
          
        }
        public static void MyMethod(object obj)
        {
            
            string str = "notepad";
            int min = 1; //больше одной минуты.
           
            Process[] allProcesses = Process.GetProcesses();
            Process[] processesByName = Process.GetProcessesByName(str);
            if (processesByName.Length==0) {
                Console.WriteLine("Процесс {0}, не найден!",str);
            }
            try
            {
                foreach (var theprocess in allProcesses)
                {
                   
                    if (theprocess.ProcessName != "idle" && theprocess.Id != 0 && theprocess.ProcessName == str)
                    {
                       
                        var procTime = DateTime.Now - theprocess.StartTime;
                        var procTimeInMin = procTime.Minutes;
                        Console.WriteLine("Проверка! Процесс: {0} занимает {1} минут.", theprocess.ProcessName, procTimeInMin);
                        if (procTimeInMin > min)
                        {
                            Console.BackgroundColor = ConsoleColor.DarkBlue;
                            Console.WriteLine("Искомый процесс превысил допустимое время!");
                            Console.WriteLine("Завершаю таймер!");
                            //theprocess.Kill();
                            timer1.Dispose();
                        }
                        
                    }

                }

            }
            catch (Win32Exception e)
            {
                Console.BackgroundColor = ConsoleColor.Blue;
                Console.WriteLine("Ошибка типа 1: {0}", e.Message);
            }
            catch (InvalidOperationException e)
            {
                Console.WriteLine("Ошибка типа 2: {0}", e.Message);
            }
            catch (SystemException e)
            {
                Console.WriteLine("Ошибка типа 3: {0}", e.Message);
            }
        }
    }
}
