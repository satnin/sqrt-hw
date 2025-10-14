#include <stdio.h>
#define TIMER_BASE 0x80008800
unsigned int *timer_status = TIMER_BASE;
unsigned int *timer_control = TIMER_BASE+4;
unsigned int *timer_periodl = TIMER_BASE+8;
unsigned int *timer_periodh = TIMER_BASE+12;
unsigned int *timer_snapl = TIMER_BASE+16;
unsigned int *timer_snaph = TIMER_BASE+20;


//****************************************************************************
//  FONCTION DE MESURE DE TEMPS
unsigned int timer_period;

void start_timer()
{
	*timer_control = 0x00000006;
}

unsigned int get_timer_period ()
{
	return ((((*timer_periodh)<<16))+(*timer_periodl));
}

unsigned int get_timer_value ()
{
	*timer_snapl = 0;
	return (((*timer_snaph)<<16)+(*timer_snapl));
}

unsigned int compute_time_interval(unsigned int v1, unsigned int v2)
{
	unsigned int time_interval;
	if (v1>=v2)
	{
		time_interval = v1-v2;
	}
	else
	{
		time_interval = v1 + timer_period - v2;
	}
	return time_interval;
}
//---------------------------------------------------------------------------------

/************************************************/
/*       Calcul racine carrée					*/
unsigned int  sqrt1(unsigned int Xio){
	if (Xio < 2) {
		return Xio;
	}
	unsigned int res = Xio >> 1, pre_res = 0;
	do 
	{
		pre_res = res;
		res = (res + Xio / res) >> 1;
	} while (pre_res != res);
	return res;
}

unsigned int  sqrt2(unsigned int Xio){
	if (Xio < 2) 
	{
		return Xio;
	}
	unsigned int n = (sizeof(unsigned int) << 3) >> 1;
	unsigned int x = 1 << ((n << 1) - 2);
	unsigned int v = 1 << (n-2);
	unsigned int z = 1 << (n-1);

	int i = n-2;
	while(i-- >= 0) 
	{
		if (x > Xio) 
		{
			x = x + v * (v - (z << 1));
			z = z - v;
		}
		else if (x < Xio) 
		{
			x = x + v * (v + (z << 1));
			z = z + v;
		}
		v = v >> 1;
	};
	
	if (x > Xio) 
	{
		return z - 1;
	}
	else 
	{
		return z;
	}
}

unsigned int  sqrt3(unsigned int Xio){
	if (Xio < 2) 
	{
		return Xio;
	}
	unsigned int n = (sizeof(unsigned int) << 3) >> 1;
	unsigned int v = 1 << ((n << 1) - 2);
	unsigned int z = 0;


	int i = n-1;
	while(i-- >= 0) 
	{
		z = z + v;
		if (((int)Xio - (int)z)>=0) 
		{
			Xio -= z;
			z = z + v;
		}
		else 
		{
			z = z - v;
		}
		z = z >> 1;
		v = v >> 2;
	}
	return z;
}

unsigned int  sqrt4(unsigned int Xio){
	if (Xio < 2) 
	{
		return Xio;
	}
	unsigned int min_ = 0, max_ = Xio;
	unsigned int res = 0;
	do 
	{
		res = (min_ + max_) >> 1;
		unsigned int carre = res * res;
		if (carre < Xio) min_ = res;
		else if (carre > Xio) max_ = res;
		else return res;
	} while ((max_ - min_) > 1);
	return min_;
}

int main()
{ 
	unsigned int first_value, second_value, res, computation_time;
	unsigned short k;
  
	timer_period = get_timer_period();

  	printf("Initialisation terminée\n");

	start_timer();
	
	computation_time = 0;

	for (k=0; k<1000; k++)
	{
		first_value = get_timer_value();
		res=sqrt1(2550409);
		second_value = get_timer_value();
		computation_time = computation_time + compute_time_interval(first_value,second_value);
	}
	

	printf("res: %u, durée sqrt1: %u\n",res,computation_time/1000);
	
	computation_time = 0;

	for (k=0; k<1000; k++)
	{
		first_value = get_timer_value();
		res=sqrt2(2550409);
		second_value = get_timer_value();
		computation_time = computation_time + compute_time_interval(first_value,second_value);
	}
	

	printf("res: %u, durée sqrt2: %u\n",res,computation_time/1000);
	
	computation_time = 0;

	for (k=0; k<1000; k++)
	{
		first_value = get_timer_value();
		res=sqrt3(2550409);
		second_value = get_timer_value();
		computation_time = computation_time + compute_time_interval(first_value,second_value);
	}
	

	printf("res: %u, durée sqrt3: %u\n",res,computation_time/1000);
	
	computation_time = 0;

	for (k=0; k<1000; k++)
	{
		first_value = get_timer_value();
		res=sqrt4(2550409);
		second_value = get_timer_value();
		computation_time = computation_time + compute_time_interval(first_value,second_value);
	}


	printf("res: %u, durée sqrt4: %u\n",res,computation_time/1000);

  return 0;
}
