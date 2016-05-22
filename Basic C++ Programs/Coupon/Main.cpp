
#include <iosteam>
using namespace std;
int main()
{
	double entered;
	cout << "ENTER IN NUM OF COUPONS";
	cin >> entered;
	cout << "You can get " << (entered-entered%10)/10 << "candy bars and " << ((entered%10)-(entered%10)%3)/3
}