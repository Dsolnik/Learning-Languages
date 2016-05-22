//percent to be taken out before constants
//constants are 10 dollars automatically and 35 if a person has more than 3 dependants
#include <iostream>
using namespace std;

int main()
{
	double hours,depend;
	cout << "How many hours worked?" << endl;
	cin >> hours;
	cout << "How many dependants do you have?" << endl;
	cin >> depend;
	double unionDues=10;
	double dependDues=0;
	cout.setf(ios::fixed);
	cout.setf(ios::showpoint);
	cout.precision(2);
	if(depend>=3)
	{
		dependDues=35;
	}
	double extra=(hours-40)*16.75*.5;
	double gross_pay = hours * 16.78 + max(0.0,extra);
	double stupid_state_taxes= gross_pay * .25;
	cout << "Your gross salary is $" << gross_pay <<endl;
	cout << "Your net salary is $" << gross_pay-stupid_state_taxes-unionDues-dependDues<< endl;
	cout << "You are paying $" << gross_pay*.06 << " in Social Security" << endl;
	cout << "You are paying $" << gross_pay*.14 << " in federal income tax"<< endl;
	cout << "You are paying $"  << gross_pay*.05 << " in state income tax."<< endl;
	cout << "You are paying $" << unionDues << " in union dues" << endl;
	cout << "You are paying $" << dependDues << " in extra health insurance dependant dues" << endl;
	system ("PAUSE");
}
