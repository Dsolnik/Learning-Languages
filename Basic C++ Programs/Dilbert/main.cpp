#include <iostream>
#include <string>
using namespace std;
int main()
{
	cout << "Enter in your name"<< endl;
	string name;
	cin >> name;
	int count=0,count2=1;
	while(count<name.length())
	{
		cout << count+1 << ". " << name.at(count-1);
	}
	cout << "\n" << name << ", there are " << name.length() << " letters in your name." << endl;
}