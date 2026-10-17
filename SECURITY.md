# Security Policy

## Reporting a Vulnerability

**Please do not report security vulnerabilities through public GitHub issues.**

If you discover a security vulnerability in STARTcloud Scripts, please report it responsibly:

### Preferred Method: Security Advisory

1. Go to the [GitHub Security Advisory page](https://github.com/STARTcloud/startcloud-scripts/security/advisories)
2. Click "Report a vulnerability"
3. Fill out the advisory form with detailed information
4. Submit the advisory

### What to Include

Please provide as much information as possible:

- **Description** of the vulnerability
- **Steps to reproduce** the issue
- **Potential impact** of the vulnerability
- **Affected versions** (if known)
- **Suggested fix** (if you have one)
- **Your contact information** for follow-up questions

## Response Process

Due to limited development resources, please understand that:

- **Initial Response**: We aim to acknowledge receipt within 48-72 hours
- **Assessment**: Initial assessment will be completed within 1 week
- **Resolution**: Timeline depends on severity and complexity, typically 1-4 weeks
- **Disclosure**: Coordinated disclosure after fix is available

### Severity Levels

- **Critical**: Immediate attention (RCE, privilege escalation)
- **High**: Quick response needed (data loss, unintended destroys)
- **Medium**: Standard timeline (DoS, information disclosure)
- **Low**: Lower priority (minor information leaks)

## Security Considerations for STARTcloud Scripts

Given that these scripts run as root from cron and destroy ZFS snapshots, please pay special attention to:

### High-Risk Areas

- **Snapshot Destroys**: Any path by which a dataset or snapshot outside the requested prefix could be destroyed
- **Argument Handling**: Unquoted expansion of the dataset path or prefix
- **Quiesce Hooks**: Execution of `quiesce` and `unquiesce` scripts found under the dataset mountpoint

## Best Practices for Users

To maintain security:

1. **Keep Updated**: Always run the latest stable version
2. **Review the cron template** before uncommenting a line
3. **Restrict `/opt/prominic/bin`** to root-writable
4. **Monitor Logs**: Watch cron mail and `zfs list -t snapshot` for unexpected changes

## Acknowledgments

We appreciate the security research community's efforts in making STARTcloud Scripts more secure. Responsible disclosure helps protect all users.

### Hall of Fame

Contributors who responsibly report security vulnerabilities will be acknowledged here (with their permission):

- _No vulnerabilities reported yet_

## Updates to This Policy

This security policy may be updated as the project evolves. Check back periodically for changes.

---

**Remember**: Security is a shared responsibility. Your vigilance and responsible reporting help keep the entire STARTcloud community safe.
