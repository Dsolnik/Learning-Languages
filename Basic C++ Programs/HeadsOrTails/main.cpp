#include <iostream>
#include <iomanip>
using namespace std;
int main()
{
	int numFlips;
	cout << "How many coins do you want to flip?" << endl;
	cin >> numFlips;
	int numT=0;
	int numH = 0;
	for(int i=0;i<numFlips;i++)
	{
		char let;
		cout << "Flip coin and enter result(H or T) #1 : ";
		cin >> let;
		cout << endl;
		if(let=='H')
		{
			numH++;
		}else{
			numT++;
		}
	}
	cout << "Results" << endl;
	cout << fixed << showpoint;
	cout << setprecision(2);
	cout << "\t" << numH << " heads, or " << numH*1.0/(numH+numT)*100 << "%" <<  endl;
	cout << "\t" << numT << " tails, or " <<  numT*1.0/(numH+numT)*100 << "%" <<endl;
	system("PAUSE");
}