package com.java.proiect.model;

public class Patterns {
    public static final String YEAR_VALIDATION = "^20[0-9][0-9]|0$"; // 2000 - 2099 | 0
    // 01-Jan-1970  -  31-Dec-2099
    public static final String DATE_OF_BIRTH = "^(([0-9])|([0-2][0-9])|([3][0-1]))\\-(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\\-(19[7-9][0-9]|20[0-9][0-9])$";
    // Ex: 3h 20m 35s (hours optional)
    public static final String LENGTH = "^(?:\\d+[hms]?|\\d+h(?:[ ]*[0-5]?\\dm)?(?:[ ]*[0-5]?\\ds)?|\\d+m[ ]*[0-5]?\\ds)$";
}
