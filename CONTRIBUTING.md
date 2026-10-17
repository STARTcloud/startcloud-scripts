# Contributing to STARTcloud Scripts

Thank you for your interest in contributing to STARTcloud Scripts! We welcome contributions from the community as they are essential for the project's continued growth and development.

## Important Note on Resources

STARTcloud Scripts is maintained with limited development resources. **Community contributions directly impact the pace of feature development and bug fixes.** The more the community contributes, the faster the project can grow and improve.

## How to Contribute

### Reporting Issues

Before creating an issue, please:

1. **Search existing issues** to avoid duplicates
2. **Use the appropriate issue template** (bug report, feature request, etc.)
3. **Provide detailed information** to help us understand and prioritize the issue
4. **Include system information** (Debian or Proxmox version, ksh version, etc.)

### Submitting Pull Requests

We appreciate all pull requests! To ensure smooth collaboration:

1. **Fork the repository** and create your feature branch from `main`
2. **Follow the existing code style** and patterns
3. **Test on a ZFS host** when possible
4. **Update documentation** if your changes affect options or the cron template
5. **Write clear commit messages** describing your changes
6. **Fill out the pull request template** completely

### Development Setup

1. Clone your fork of the repository
2. Install the runtime: `sudo apt install ksh93u+m zfsutils-linux shellcheck`
3. Lint: `shellcheck --severity=error src/*.sh`
4. Build the package as described in [packaging/README.md](packaging/README.md)

### Code Style Guidelines

- Follow existing ksh conventions
- Use meaningful variable and function names
- Keep scripts focused and small
- Use absolute paths for system binaries

### What We're Looking For

**High Impact Contributions:**

- Bug fixes (especially those affecting snapshot retention)
- Safety improvements around destroys
- Documentation improvements

**Feature Contributions:**

- New operational scripts for Debian and Proxmox hosts
- Better error handling

## Response Times and Review Process

Due to limited development resources:

- **Issue responses**: We aim to acknowledge new issues within a few days
- **Pull request reviews**: Reviews may take weeks depending on complexity and current workload
- **Feature requests**: Prioritized based on community needs and available resources
- **Documentation updates**: Generally reviewed quickly as they're high-impact, low-risk

## Getting Help

If you need help with contributing:

- **GitHub Discussions**: Ask questions about development
- **Issues**: Use the "question" template for specific inquiries
- **Documentation**: Check the [README](README.md)

## Recognition

All contributors are recognized in our [AUTHORS.md](AUTHORS.md) file. We appreciate every contribution, from small bug fixes to major features!

## Code of Conduct

Please note that this project follows our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you agree to abide by its terms.

## License

By contributing to STARTcloud Scripts, you agree that your contributions will be licensed under the [GPL-3.0 License](LICENSE.md).

---

**Remember**: Your contributions directly influence the project's development speed and capabilities. Thank you for helping make STARTcloud Scripts better for everyone!
