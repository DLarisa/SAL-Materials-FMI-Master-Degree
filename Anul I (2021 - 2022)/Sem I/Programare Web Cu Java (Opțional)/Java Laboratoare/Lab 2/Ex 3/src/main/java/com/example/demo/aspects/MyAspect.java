package com.example.demo.aspects;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;

@Aspect
// Nu putem să adnotăm cu @Component, tb pus explicit @Bean în clasa de configurare
public class MyAspect {
    /*
        Un aspect conține:
        - JoinPoint: locul în care aspectul se aplică (metoda interceptată) / aspectul face interceptarea
        - PointCut: identifică locul unde tb să se facă interceptarea (expresia dată care conduce unde să se execute JoinPoint-ul)
        - Advice: logica de bussiness (când și cum rulăm noua logică raportat la locul interceptat)
        =====================================================================================================
        5 tipuri de Advice:
        1) Before (advice)
        2) After (advice)
        3) After returning (advice)
        4) After throwing (advice)
        5) Around -> CEL MAI PUTERNIC

        Primele 4 primesc ca parametru un JointPoint; al 5-lea primește un proceeding JointPoint, prin care poți schimba
        comportamentul unei metode. Cumva Around se execută și înainte și după.
        ===========================================================================================================
        Pași lucrul cu aspecte:
        1. @EnableAspectJAutoProxy
        2. definirea clasei de aspect prin adnotarea de @Aspect
        3. adăugarea aspectului în context (by default @Aspect nu adaugă în context)
     */

    // Definire PointCut
    @Pointcut(value = "execution(* MainService.*(..))")
    public void operation(){}

    // Definire Advice
//    @Before("operation()")
//    public void log(JoinPoint joinPoint) {
//        System.out.println("Logging before " + joinPoint.getSignature().getName());
//    }

    @Around("operation()")
    public Object log(ProceedingJoinPoint proceedingJoinPoint) {
        System.out.println("Logging before " + proceedingJoinPoint.getSignature().getName());
        try {
            Object result = proceedingJoinPoint.proceed(new Object[] {"other test data"}); // aici schimbă comportamentul
            //  Object result = proceedingJoinPoint.proceed();
            return result;
        } catch (Throwable e) {
            e.printStackTrace();
        }
        return null;
    }
}
