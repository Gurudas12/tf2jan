


emitBatchSize:
	File input : 1gb.file
	value=2        timeToCopy ~ 70 minutes
	value=100      timeToCopy ~ 8 minutes
	value=1000     timeToCopy ~ 8 minutes






FSInput_Test_filePatternRegexp-all-filtered-out
    [Setup]    Dtcli Enter
    ${params}=    Create Dictionary    dt.operator.read.prop.directory=${BASE_INDIR}/file-filter-input-dir    dt.operator.write.prop.filePath=${BASE_OUTDIR}/${TEST_NAME}    dt.operator.read.prop.scanner.filePatternRegexp=.*\\.file
    RUNit    ${params}    filefilter=qwerty
    [Teardown]    Dtcli Exit    ${app_id}    kill=${True}

