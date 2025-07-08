$reports = undef
$foreman = false
$puppetdb = true

  $server_reports = [
    $reports,
    $puppetdb ? { true => 'puppetdb', false => undef },
    $foreman  ? { true => 'foreman',  false => undef },
  ].filter |$i| { $i }.join(',')

notice($server_reports)
