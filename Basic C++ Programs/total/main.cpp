#include <iostream>
using namespace std;
int main()
{
	double total=0;
	for(int i=0;i<5;i++)
	{
		double num;
		cout << "Enter in a number." << endl;
		cin >> num;
		total+=num;
	}
	cout << "The average of the 5 is " << total/5.0 << endl;
	system("PAUSE");
}