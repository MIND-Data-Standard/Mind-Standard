# 🧠 MIND Data Standard

**MIND (Multimodal Interoperable N Dimensional)** is an open data standard for representing, synchronising, and sharing high-fidelity behavioural and physiological datasets across experiments.

This repository contains the **core specification**, **schemas**, and **examples** defining the MIND standard.  
It provides a structured framework for recording multimodal, irregular timeseries data from XR applications and biosensors.

---

## 📘 Specification contents

| Folder | Description |
|---------|--------------|
| [`specification/`](specification/) | Human-readable documentation of the MIND standard. |
| [`schema/`](schema/) | Machine-readable JSON Schemas describing the data model. |
| [`examples/`](examples/) | Example datasets showing valid MIND-format files. |
| [`docs/`](docs/) | Contributor and governance documentation. |

---

## 🔗 Reference implementations

| Language | Repository | Status |
|-----------|-------------|---------|
| C# / Unity | [SilicoLabs/mind-csharp](https://github.com/SilicoLabs/mind-csharp) | ✅ Active |
| Python | (coming soon) | 🚧 Planned |

---

## 🧩 License

This specification is released under the **Creative Commons Attribution 4.0 International (CC BY 4.0)** license.  
See [LICENSE](LICENSE) for details.

---

## ✍️ Citation

If you use the MIND standard in your work, please cite it as:

```bibtex
@misc{MIND-Standard,
  author       = {SilicoLabs},
  title        = {MIND Data Standard: Specification Repository},
  year         = {2025},
  url          = {https://github.com/SilicoLabs/MIND-Standard},
  note         = {Version 1.0.0, CC-BY-4.0 License}
}
```

---

---

## 🤝 Contributing

Contributions to the MIND specification are welcome from researchers, developers, and organisations working in neuroscience, cognitive science, XR, and related domains.

We encourage discussion through **GitHub Issues** and **Pull Requests**.  
If you find something unclear, inconsistent, or incomplete — please open an issue with as much context as possible.

### 🧩 How to Contribute

1. **Open an Issue**  
   Describe the proposed change, addition, or clarification.  
   Link to relevant sections of the specification or examples if possible.

2. **Fork and Edit**  
   Create a branch from `main`, make your proposed edits in the relevant Markdown or schema files, and commit with clear messages.

3. **Submit a Pull Request**  
   Include a short summary of your changes and the reasoning behind them.  
   Pull requests are reviewed by maintainers and subject-matter experts before being merged.

4. **Extensions and Experimental Fields**  
   The MIND specification supports extensions for specific research domains or modalities (e.g., haptics, eye-tracking).  
   If you are developing an extension, please prefix its schema with `mindx-` and submit a proposal for review.

Before contributing, please read the [Governance Guidelines](GOVERNANCE.md) and [Contributing Guide](CONTRIBUTING.md) for details on the decision process, review stages, and extension approval.

---

## 🧠 Governance

The MIND standard is coordinated by **SilicoLabs**, in consultation with an advisory network of researchers and partners.  
The goal is to maintain transparency, interoperability, and community stewardship of the specification.

### Decision Process
- Minor editorial fixes are merged after review by one maintainer.  
- Substantive changes or new features require a public discussion period and approval by two maintainers.  
- Major version releases (e.g., 1.0 → 2.0) include formal review and community feedback.

Versioned releases are archived on **Zenodo** and receive a DOI for citation.

For more details, see [GOVERNANCE.md](GOVERNANCE.md).

---

## 🧾 License

The MIND specification and documentation are released under the  
**Creative Commons Attribution 4.0 International (CC BY 4.0)** license.

You are free to share and adapt the material for any purpose, provided that appropriate credit is given to the original authors.  
See the [LICENSE](LICENSE) file for the full legal text.

---

## ✍️ Citation

If you use the MIND standard in your research, software, or publications, please cite it as follows:

**BibTeX**
```bibtex
@misc{MIND-Standard,
  author       = {SilicoLabs},
  title        = {MIND Data Standard: Specification Repository},
  year         = {2025},
  url          = {https://github.com/SilicoLabs/MIND-Standard},
  note         = {Version 1.0.0, CC-BY-4.0 License}
}
```

You can also import this citation directly via the [`CITATION.cff`](CITATION.cff) file.

---

## 🔗 Related Repositories

| Repository | Description | License |
|-------------|--------------|----------|
| [mind-csharp](https://github.com/SilicoLabs/mind-csharp) | Reference C# implementation (Unity / .NET) | MIT |
| mind-python *(coming soon)* | Python SDK for data loading and validation | MIT |
| mind-validator *(planned)* | Cross-language schema validator CLI | MIT |

---

## 📬 Contact

For questions, collaborations, or partnership inquiries, please contact  
**SilicoLabs** — [info@silicolabs.ca](mailto:info@silicolabs.ca)  
or open a discussion on [GitHub Discussions](https://github.com/SilicoLabs/MIND-Standard/discussions)

---

© 2025 SilicoLabs. Released under the Creative Commons Attribution 4.0 License (CC-BY-4.0).

