package com.deque.axe;

import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.After;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TestName;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.remote.RemoteWebDriver;

import java.net.URL;
import java.util.Arrays;
import java.util.Collection;

import static org.junit.Assert.assertTrue;

@RunWith(Parameterized.class)
public class ShahidParameterTest {

    private  String pageUrl;
    @Rule
    public TestName testName = new TestName();

    private WebDriver driver;

    private static final URL scriptUrl = ShahidParameterTest.class.getResource("/axe.min.js");
    /**
     * Instantiate the WebDriver and navigate to the test site
     */
    @Before
    public void setUp() {

// chrome driver
        System.setProperty("webdriver.chrome.driver", "C:\\Users\\557897\\Downloads\\chromedriver.exe");

        ChromeOptions options = new ChromeOptions();
        options.addArguments("--headless", "--disable-gpu");
        driver =  new ChromeDriver( options );
        //driver.manage().window().maximize(); // maximize web browser
        driver.manage().deleteAllCookies();

         //driver = new FirefoxDriver();
        //driver.get("https://www.papajohnspizza.in/");
        //driver.findElement(By.linkText("Menu")).click();
    }

    /**
     * Ensure we close the WebDriver after finishing
     */
    @After
    public void tearDown() {
        driver.quit();
    }


    public ShahidParameterTest(String pageUrl) {
        this.pageUrl = pageUrl;
    }

    /**
     * Basic test
     */
    @Test
    public void testAccessibility() {
        System.out.println("BEGINNING OF NEW TEST FOR :: "+ pageUrl);
        driver.get(pageUrl);
        driver.findElement(By.linkText("Menu")).click();
        pageUrl=driver.getCurrentUrl();
        JSONObject responseJSON = new AXE.Builder(driver, scriptUrl).analyze();

        JSONArray violations = responseJSON.getJSONArray("violations");
        System.out.println("VIOLATIONS:: "+violations);
        //String urlFromJSON = responseJSON.getString("url"); //Get URL of the page that is tested
        //System.out.println("URL IS  ::"+urlFromJSON);
        if (violations.length() == 0) {
            assertTrue("No violations found", true);
        } else {
            AXE.writeResults(testName.getMethodName(), responseJSON);

            assertTrue(AXE.report(violations,pageUrl), false);
        }
    }


    /**
	 * Test a specific selector or selectors
	 */
	@Test
	public void testAccessibilityWithSelector() {
		JSONObject responseJSON = new AXE.Builder(driver, scriptUrl)
				.include("title")
				.include("p")
				.analyze();

		JSONArray violations = responseJSON.getJSONArray("violations");

		if (violations.length() == 0) {
			assertTrue("No violations found", true);
		} else {
			AXE.writeResults(testName.getMethodName(), responseJSON);

			assertTrue(AXE.report(violations,pageUrl), false);
		}
	}

    @Parameterized.Parameters
    public static Collection listOfUrls() {

        return Arrays.asList(
                 "https://www.papajohnspizza.in/","https://www.papajohnspizza.in/aboutus"
        );
    }

}
