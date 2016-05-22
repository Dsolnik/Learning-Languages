#include <iostream>
using namespace std;
int main()
{
	int num;
	cout << "Enter in number of words" << endl;
	cin >> num;
	if(num >15)
	{
		cout << "It costs $" << (num-15)*.25+ 8.5<< " to send it" << endl;
	}else
	{
		cout << "It costs $" << num*8.5<< "to send it" << endl;
	}
	system("PAUSE");

}