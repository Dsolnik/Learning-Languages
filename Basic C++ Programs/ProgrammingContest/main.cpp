#include <iostream>
using namespace std;
int main()
{
	double players;
	cout << "HOW MANY PlAYERS"<< endl;
	cin >> players;
	int teams=players/5;
	if(players-teams*5==0)
	{
		cout << "There will be " << teams << " teams and " << players-teams*5 << " left over." << endl;
	}else
	{
		cout << "There will be " << teams << " teams and " << players-teams*5 << " left over." << endl;
	}
	system("PAUSE");
}