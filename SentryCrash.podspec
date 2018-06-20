Pod::Spec.new do |s|
  IOS_DEPLOYMENT_TARGET = '6.0' unless defined? IOS_DEPLOYMENT_TARGET
  s.name         = "SentryCrash"
  s.version      = "1.15.18"
  s.summary      = "The Ultimate iOS Crash Reporter"
  s.homepage     = "https://github.com/kstenerud/SentryCrash"
  s.license     = { :type => 'SentryCrash license agreement', :file => 'LICENSE' }
  s.author       = { "Karl Stenerud" => "kstenerud@gmail.com" }
  s.ios.deployment_target =  IOS_DEPLOYMENT_TARGET
  s.osx.deployment_target =  '10.8'
  s.tvos.deployment_target =  '9.0'
  s.watchos.deployment_target =  '2.0'
  s.source       = { :git => "https://github.com/kstenerud/SentryCrash.git", :tag=>s.version.to_s }
  s.frameworks = 'Foundation'
  s.libraries = 'c++', 'z'
  s.xcconfig = { 'GCC_ENABLE_CPP_EXCEPTIONS' => 'YES' }
  s.default_subspecs = 'Installations'

  s.subspec 'Recording' do |recording|
    recording.source_files   = 'Source/SentryCrash/Recording/**/*.{h,m,mm,c,cpp}',
                               'Source/SentryCrash/llvm/**/*.{h,m,mm,c,cpp}',
                               'Source/SentryCrash/swift/**/*.{h,m,mm,c,cpp}',
                               'Source/SentryCrash/Reporting/Filters/SentryCrashReportFilter.h'
    recording.public_header_files = 'Source/SentryCrash/Recording/SentryCrash.h',
                                    'Source/SentryCrash/Recording/SentryCrashC.h',
                                    'Source/SentryCrash/Recording/SentryCrashReportWriter.h',
                                    'Source/SentryCrash/Recording/SentryCrashReportFields.h',
                                    'Source/SentryCrash/Recording/Monitors/SentryCrashMonitorType.h',
                                    'Source/SentryCrash/Reporting/Filters/SentryCrashReportFilter.h'

    recording.subspec 'Tools' do |tools|
      tools.source_files = 'Source/SentryCrash/Recording/Tools/*.h'
    end
  end

  s.subspec 'Reporting' do |reporting|
    reporting.dependency 'SentryCrash/Recording'

    reporting.subspec 'Filters' do |filters|
      filters.subspec 'Base' do |base|
        base.source_files = 'Source/SentryCrash/Reporting/Filters/Tools/**/*.{h,m,mm,c,cpp}',
                            'Source/SentryCrash/Reporting/Filters/SentryCrashReportFilter.h'
        base.public_header_files = 'Source/SentryCrash/Reporting/Filters/SentryCrashReportFilter.h'
      end

      filters.subspec 'Alert' do |alert|
        alert.dependency 'SentryCrash/Reporting/Filters/Base'
        alert.source_files = 'Source/SentryCrash/Reporting/Filters/SentryCrashReportFilterAlert.h',
                             'Source/SentryCrash/Reporting/Filters/SentryCrashReportFilterAlert.m'
      end

      filters.subspec 'AppleFmt' do |applefmt|
        applefmt.dependency 'SentryCrash/Reporting/Filters/Base'
        applefmt.source_files = 'Source/SentryCrash/Reporting/Filters/SentryCrashReportFilterAppleFmt.h',
                             'Source/SentryCrash/Reporting/Filters/SentryCrashReportFilterAppleFmt.m'
      end

      filters.subspec 'Basic' do |basic|
        basic.dependency 'SentryCrash/Reporting/Filters/Base'
        basic.source_files = 'Source/SentryCrash/Reporting/Filters/SentryCrashReportFilterBasic.h',
                             'Source/SentryCrash/Reporting/Filters/SentryCrashReportFilterBasic.m'
      end

      filters.subspec 'Stringify' do |stringify|
        stringify.dependency 'SentryCrash/Reporting/Filters/Base'
        stringify.source_files = 'Source/SentryCrash/Reporting/Filters/SentryCrashReportFilterStringify.h',
                                 'Source/SentryCrash/Reporting/Filters/SentryCrashReportFilterStringify.m'
      end

      filters.subspec 'GZip' do |gzip|
        gzip.dependency 'SentryCrash/Reporting/Filters/Base'
        gzip.source_files = 'Source/SentryCrash/Reporting/Filters/SentryCrashReportFilterGZip.h',
                            'Source/SentryCrash/Reporting/Filters/SentryCrashReportFilterGZip.m'
      end

      filters.subspec 'JSON' do |json|
        json.dependency 'SentryCrash/Reporting/Filters/Base'
        json.source_files = 'Source/SentryCrash/Reporting/Filters/SentryCrashReportFilterJSON.h',
                            'Source/SentryCrash/Reporting/Filters/SentryCrashReportFilterJSON.m'
      end

      filters.subspec 'Sets' do |sets|
        sets.dependency 'SentryCrash/Reporting/Filters/Base'
        sets.dependency 'SentryCrash/Reporting/Filters/AppleFmt'
        sets.dependency 'SentryCrash/Reporting/Filters/Basic'
        sets.dependency 'SentryCrash/Reporting/Filters/Stringify'
        sets.dependency 'SentryCrash/Reporting/Filters/GZip'
        sets.dependency 'SentryCrash/Reporting/Filters/JSON'

        sets.source_files = 'Source/SentryCrash/Reporting/Filters/SentryCrashReportFilterSets.h',
                            'Source/SentryCrash/Reporting/Filters/SentryCrashReportFilterSets.m'
      end

      filters.subspec 'Tools' do |tools|
        tools.source_files = 'Source/SentryCrash/Reporting/Filters/Tools/**/*.{h,m,mm,c,cpp}'
      end

    end

    reporting.subspec 'Tools' do |tools|
      tools.ios.frameworks = 'SystemConfiguration'
      tools.tvos.frameworks = 'SystemConfiguration'
      tools.osx.frameworks = 'SystemConfiguration'
      tools.source_files = 'Source/SentryCrash/Reporting/Tools/**/*.{h,m,mm,c,cpp}',
                           'Source/SentryCrash/Recording/KSSystemCapabilities.h'
    end

    reporting.subspec 'MessageUI' do |messageui|
    end

    reporting.subspec 'Sinks' do |sinks|
      sinks.ios.frameworks = 'MessageUI'
      sinks.dependency 'SentryCrash/Reporting/Filters'
      sinks.dependency 'SentryCrash/Reporting/Tools'
      sinks.source_files = 'Source/SentryCrash/Reporting/Sinks/**/*.{h,m,mm,c,cpp}'
    end

  end

  s.subspec 'Installations' do |installations|
    installations.dependency 'SentryCrash/Recording'
    installations.dependency 'SentryCrash/Reporting'
    installations.source_files = 'Source/SentryCrash/Installations/**/*.{h,m,mm,c,cpp}'
  end

  s.subspec 'Core' do |core|
    core.dependency 'SentryCrash/Reporting/Filters/Basic'
    core.source_files = 'Source/SentryCrash/Installations/SentryCrashInstallation.h',
                        'Source/SentryCrash/Installations/SentryCrashInstallation.m',
                        'Source/SentryCrash/Installations/SentryCrashInstallation+Private.h',
                        'Source/SentryCrash/Reporting/Tools/KSCString.{h,m}'
  end

end
