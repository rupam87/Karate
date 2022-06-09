package karate;

import com.intuit.karate.KarateOptions;
import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.apache.commons.io.FileUtils;
import org.junit.Test;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import static org.junit.Assert.assertTrue;

//@KarateOptions(features = "classpath:features/", tags = {"~@ignore"})
public class KarateRunner {

    @Test
    public void testParallel() {
        //System.setProperty("karate.env","qa");
        System.out.println("Karate.env =" + System.getProperty("Karate.env").toString());
        String karateOutputPath = "target/reports";
        Results results = Runner.path("classpath:features/").reportDir(karateOutputPath).tags("~@ignore").parallel(2);
        System.out.println("Reports Path: " + results.getReportDir());
        //generateReport(results.getReportDir());
        assertTrue(results.getErrorMessages(), results.getFailCount() == 0);
    }

    public static void generateReport(String karateOutputPath) {
        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[]{"txt"}, true);
        List<String> jsonPaths = new ArrayList<String>(jsonFiles.size());
        jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
        Configuration config = new Configuration(new File("target"), "API Tests");
        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
        reportBuilder.generateReports();
    }
}
