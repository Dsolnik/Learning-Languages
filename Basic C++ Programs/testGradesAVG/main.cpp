#include <iostream>
#include <iomanip>
 using namespace std;

int main()
{
     int grade, total = 0, count = 0;
     double average;
     cout.setf(ios::fixed);
     cout.setf(ios::showpoint);
     cout<<setprecision(1);
     do
     {
          cout<<"Please enter your grades one at a time (enter -99 to quit):";
          cin>>grade;
          total = total + grade;
          count++;
     {
     while (grade != -99);
     average = total/count;
     cout<<"Your average is "<<average<<".";
     return 0;

}