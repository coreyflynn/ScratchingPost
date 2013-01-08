import org.genepattern.matrix.Dataset;
import org.genepattern.client.GPClient;
import org.genepattern.webservice.JobResult;
import org.genepattern.webservice.Parameter;
import org.genepattern.io.IOUtil;
import java.io.File;

public class KNNGenePattern {
   public static void main(String[] args)
                    throws Exception {
      GPClient gpClient=new GPClient("http://localhost:8080", 
                                     "cflynn@broadinstitute.org");
JobResult result = gpClient.runAnalysis("urn:lsid:broad.mit.edu:cancer.software.genepattern.module.analysis:00012:4", new Parameter[]{new Parameter("train.filename", args[0]), new Parameter("train.class.filename", args[1]), new Parameter("saved.model.filename", ""), new Parameter("model.file", "<train.filename_basename>.model"), new Parameter("test.filename", args[2]), new Parameter("test.class.filename", args[1]), new Parameter("num.features", "10"), new Parameter("feature.selection.statistic", "0"), new Parameter("min.std", ""), new Parameter("feature.list.filename", args[3]), new Parameter("num.neighbors", "3"), new Parameter("weighting.type", "3"), new Parameter("distance.measure", "2"), new Parameter("pred.results.file", "<test.filename_basename>.pred.odf")});
    
    String downloadDirName=String.valueOf(result.getJobNumber());
    // download result files
    File[] outputFiles = result.downloadFiles(downloadDirName);
    System.out.print("FILE\n");
    System.out.print(outputFiles[0]);
   }
}