package org.stenerud.sentrycrash;

import org.json.JSONObject;
import org.junit.Test;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import static org.junit.Assert.assertEquals;

/**
 * Created by karl on 2017-01-12.
 */

public class SentryCrashReportFilterJSONEncodeTest {
    @Test
    public void test_encode_dictionary() throws Exception {
        final String expected = "{}";
        Map dictionary = new HashMap();
        List reports = new LinkedList();
        reports.add(new JSONObject(dictionary));
        SentryCrashReportFilter filter = new SentryCrashReportFilterJSONEncode();
        filter.filterReports(reports, new SentryCrashReportFilter.CompletionCallback() {
            @Override
            public void onCompletion(List reports) throws SentryCrashReportFilteringFailedException {
                assertEquals(expected, reports.get(0));
            }
        });
    }
}
