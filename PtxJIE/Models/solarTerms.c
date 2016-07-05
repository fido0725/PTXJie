//
//  solarTerms.c
//  PtxJIE
//
//  Created by ptx on 16/6/30.
//  Copyright © 2016年 fido0725. All rights reserved.
//

#include "solarTerms.h"

double CalcPeriodicTerm(const VSOP87_COEFFICIENT *coff, int count, double dt)
{
    double val = 0.0;
    
    for(int i = 0; i < count; i++)
        val += (coff[i].A * cos((coff[i].B + coff[i].C * dt)));
    
    return val;
}

double CalcSunEclipticLatitudeEC(double dt)
{
    double B0 = CalcPeriodicTerm(Earth_B0, sizeof(Earth_B0) / sizeof(VSOP87_COEFFICIENT), dt);
    double B1 = CalcPeriodicTerm(Earth_B1, sizeof(Earth_B1) / sizeof(VSOP87_COEFFICIENT), dt);
    double B2 = CalcPeriodicTerm(Earth_B2, sizeof(Earth_B2) / sizeof(VSOP87_COEFFICIENT), dt);
    double B3 = CalcPeriodicTerm(Earth_B3, sizeof(Earth_B3) / sizeof(VSOP87_COEFFICIENT), dt);
    double B4 = CalcPeriodicTerm(Earth_B4, sizeof(Earth_B4) / sizeof(VSOP87_COEFFICIENT), dt);
    
    double B = (((((B4 * dt) + B3) * dt + B2) * dt + B1) * dt + B0) / 100000000.0;
    
    /*地心黄纬 = －日心黄纬*/
    return -(B / RADIAN_PER_ANGLE);
}

double CalcSunEclipticLongitudeEC(double dt)
{
    double L0 = CalcPeriodicTerm(Earth_L0, sizeof(Earth_L0) / sizeof(VSOP87_COEFFICIENT), dt);
    double L1 = CalcPeriodicTerm(Earth_L1, sizeof(Earth_L1) / sizeof(VSOP87_COEFFICIENT), dt);
    double L2 = CalcPeriodicTerm(Earth_L2, sizeof(Earth_L2) / sizeof(VSOP87_COEFFICIENT), dt);
    double L3 = CalcPeriodicTerm(Earth_L3, sizeof(Earth_L3) / sizeof(VSOP87_COEFFICIENT), dt);
    double L4 = CalcPeriodicTerm(Earth_L4, sizeof(Earth_L4) / sizeof(VSOP87_COEFFICIENT), dt);
    double L5 = CalcPeriodicTerm(Earth_L5, sizeof(Earth_L5) / sizeof(VSOP87_COEFFICIENT), dt);
    
    double L = (((((L5 * dt + L4) * dt + L3) * dt + L2) * dt + L1) * dt + L0) / 100000000.0;
    
    /*地心黄经 = 日心黄经 + 180度*/
    return (Mod360Degree(Mod360Degree(L / RADIAN_PER_ANGLE) + 180.0));
}

double AdjustSunEclipticLongitudeEC(double dt, double longitude, double latitude)
{
    double T = dt * 10; //T是儒略世纪数
    
    double dbLdash = longitude - 1.397 * T - 0.00031 * T * T;
    
    // 转换为弧度
    dbLdash *= RADIAN_PER_ANGLE;
    
    return (-0.09033 + 0.03916 * (cos(dbLdash) + sin(dbLdash)) * tan(latitude * RADIAN_PER_ANGLE)) / 3600.0;
}

double GetSunEclipticLongitudeEC(double jde)
{
    double dt = (jde - JD2000) / 365250.0; /*儒略千年数*/
    
    // 计算太阳的地心黄经
    double longitude = CalcSunEclipticLongitudeEC(dt);
    
    // 计算太阳的地心黄纬
    double latitude = CalcSunEclipticLatitudeEC(dt) * 3600.0;
    
    // 修正精度
    longitude += AdjustSunEclipticLongitudeEC(dt, longitude, latitude);
    
    // 修正天体章动
    longitude += CalcEarthLongitudeNutation(dt);
    
    // 修正光行差
    /*太阳地心黄经光行差修正项是: -20".4898/R*/
    longitude -= (20.4898 / CalcSunEarthRadius(dt)) / (20 * PI);
    
    return longitude;
}

double CalculateSolarTermsNewton(int year, int angle)
 {
        double JD0, JD1,stDegree,stDegreep;
    
        JD1 = GetInitialEstimateSolarTerms(year, angle);
        do
          {
                    JD0 = JD1;
                    stDegree = GetSunEclipticLongitudeECDegree(JD0) - angle;
                    stDegreep = (GetSunEclipticLongitudeECDegree(JD0 + 0.000005)
                                 84                       - GetSunEclipticLongitudeECDegree(JD0 - 0.000005)) / 0.00001;
                    JD1 = JD0 - stDegree / stDegreep;
             }while((fabs(JD1 - JD0) > 0.0000001));
    
        return JD1;
}

