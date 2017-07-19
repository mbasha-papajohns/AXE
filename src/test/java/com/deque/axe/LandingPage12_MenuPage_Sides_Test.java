package com.deque.axe;

import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.After;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TestName;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

import java.net.URL;
import java.util.concurrent.TimeUnit;

import static org.junit.Assert.assertTrue;

/**
 * Created by 494301 on 5/22/2017.
 */
public class LandingPage12_MenuPage_Sides_Test {


    @Rule
    public TestName testName = new TestName();
    public String pageUrl;
    public WebDriver driver;

    public static void callMeToWait(int milliSec) {
        try {
            Thread.sleep(milliSec);
        } catch (InterruptedException ie) {
            ie.printStackTrace();
        }
    }

    private static final URL scriptUrl = LandingPage12_MenuPage_Sides_Test.class.getResource("/axe.min.js");


    /**
     * Instantiate the WebDriver and navigate to the test site
     */
    @Before
    public void Test() {

        // chrome driver
		System.setProperty("webdriver.chrome.driver", "//root//RPMS//chromedriver_linux64//chromedriver");

        ChromeOptions options = new ChromeOptions();
		options.addArguments("--headless", "--disable-gpu");
		driver =  new ChromeDriver( options );
        //driver.manage().window().maximize(); // maximize web browser
        //driver.manage().deleteAllCookies();



        // to give the application url
        driver.get("https://www.papajohns.com");
        LandingPage12_MenuPage_Sides_Test.callMeToWait(5000);




        // DO User login
        // TO Click On Sign In Button
        driver.findElement(By.xpath("//a[@class='sign-in-link']")).click();
        LandingPage12_MenuPage_Sides_Test.callMeToWait(5000);


        // TO type Email
        driver.findElement(By.id("omnibar-account-sign-in-email")).sendKeys("pjirwdsmokesuite@gmail.com");

        // to type passsword
        driver.findElement(By.id("omnibar-account-sign-in-password")).sendKeys("Papajohns1");


        // submit sign in
        // User navigated to Menu Page
        driver.findElement(By.xpath("//input[@value='Sign In']")).click(); // submit sign in
        driver.manage().timeouts().implicitlyWait(30, TimeUnit.SECONDS);


        // Menu_Sides Page
        driver.findElement(By.xpath("//nav[@class='secondary-nav']//li[@class='secondary-nav-item']//a[contains(.,'Sides')]")).click(); // submit sign in
        driver.manage().timeouts().implicitlyWait(30, TimeUnit.SECONDS);
        LandingPage12_MenuPage_Sides_Test.callMeToWait(5000);

        pageUrl = driver.getCurrentUrl();

    }


    @Test
    public void testAccessibility () {
        // System.out.println("BEGINNING OF NEW TEST FOR :: " + pageUrl);
        //  driver.get(pageUrl);
        // driver.manage().window().maximize();
        JSONObject responseJSON = new AXE.Builder(driver, scriptUrl).analyze();

        JSONArray violations = responseJSON.getJSONArray("violations");
        System.out.println("VIOLATIONS:: " + violations);
        //String urlFromJSON = responseJSON.getString("url"); //Get URL of the page that is tested
        //System.out.println("URL IS  ::"+urlFromJSON);
        if (violations.length() == 0) {
            assertTrue("No violations found", true);
        } else {
            AXE.writeResults(testName.getMethodName(), responseJSON);

            assertTrue(AXE.report(violations, pageUrl), false);
        }
    }



    /**
     * Ensure we close the WebDriver after finishing
     */
    @After
    public void tearDown () {
        driver.quit();
    }


}
