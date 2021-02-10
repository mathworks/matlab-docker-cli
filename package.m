

import matlab.unittest.TestSuite
import matlab.unittest.TestRunner
import matlab.unittest.plugins.CodeCoveragePlugin

suite = TestSuite.fromPackage("test.docker");

runner = TestRunner.withTextOutput;

runner.addPlugin(...
    CodeCoveragePlugin.forPackage("docker","IncludingSubpackages",true));

result = runner.run(suite);


projectFile = "MATLAB Interface for Desktop Docker Client.prj";
outputFile = "MATLABInterfaceForDockerDesktopClient";
matlab.addons.toolbox.packageToolbox(projectFile,outputFile);