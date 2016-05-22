#include <iostream>
#include <string>
using namespace std;
int main()
{
	string name;
	cout << "enter in your name " << endl;
	cin >> name;
	int num;
	cout << "enter in amt of times to say " << endl;
	cin >> num;
	int count=0;
	do{
		cout << name << endl;
		count++;
	}while(count<num);
	system("PAUSE");
}