#include <iostream>
using namespace std;
int main()
{
	double inches;
	cout << "Enter inches " << endl;
	cin >> inches;
	int feet = inches/12;
	cout << "That is " << feet << " feet and " << inches - feet*12 << " inches." << endl;
	system("PAUSE");

}