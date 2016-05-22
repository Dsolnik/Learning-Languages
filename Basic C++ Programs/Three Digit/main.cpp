#include <iostream>
using namespace std;
int main()
{
	int num;
	cout << "Enter a three digit number: " << endl;
	cin >> num;
	cout << "The first digit is " << num/100 << " \n the second is " << (num-num/100*100)/10 << "\n the third is " << num- (num-num/100*100)/10*10 - num/100*100<< endl;
	cout << "Sum is " << num/100+(num-num/100*100)/10+ num- (num-num/100*100)/10*10 - num/100*100<< " \n";
	system("PAUSE");
}