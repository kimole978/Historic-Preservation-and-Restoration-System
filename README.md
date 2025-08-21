# Historic Preservation and Restoration System

A comprehensive blockchain-based system for managing historic preservation projects, craftsperson qualifications, regulatory compliance, and grant funding coordination.

## System Overview

This system consists of five interconnected Clarity smart contracts that work together to provide a complete solution for historic preservation management:

### Core Contracts

1. **Heritage Registry (`heritage-registry.clar`)**
    - Manages historic properties and their preservation status
    - Tracks heritage classifications and protection levels
    - Maintains property ownership and custodian records

2. **Craftsperson Registry (`craftsperson-registry.clar`)**
    - Manages qualified craftsperson profiles and certifications
    - Tracks specialized skills and traditional techniques
    - Handles certification renewals and skill assessments

3. **Project Management (`project-management.clar`)**
    - Coordinates preservation and restoration projects
    - Manages project phases, milestones, and deliverables
    - Tracks project costs, timelines, and compliance requirements

4. **Regulatory Compliance (`regulatory-compliance.clar`)**
    - Manages permits, approvals, and regulatory requirements
    - Tracks compliance status and inspection records
    - Handles regulatory body interactions and documentation

5. **Grant Funding (`grant-funding.clar`)**
    - Manages grant applications and funding allocation
    - Tracks funding sources and disbursement schedules
    - Coordinates between multiple funding bodies and projects

## Key Features

### Heritage Compliance Management
- Property registration and classification
- Preservation standard enforcement
- Historical significance documentation
- Protection level assignment

### Craftsperson Qualification System
- Skill certification and verification
- Traditional technique preservation
- Continuing education tracking
- Performance evaluation system

### Transparent Project Documentation
- Complete project lifecycle tracking
- Milestone-based progress reporting
- Cost and timeline management
- Quality assurance protocols

### Regulatory Compliance
- Automated permit tracking
- Inspection scheduling and results
- Compliance status monitoring
- Regulatory body coordination

### Grant Funding Coordination
- Multi-source funding management
- Disbursement tracking
- Performance-based releases
- Financial transparency

## Data Types

### Heritage Property
- Property ID and location details
- Historical significance rating
- Current preservation status
- Custodian and ownership information

### Craftsperson Profile
- Unique craftsperson ID
- Skill certifications and levels
- Traditional technique specializations
- Performance history and ratings

### Project Record
- Project identification and scope
- Associated heritage properties
- Assigned craftspersons and teams
- Timeline, budget, and milestones

### Regulatory Status
- Permit and approval tracking
- Inspection schedules and results
- Compliance requirements
- Regulatory body contacts

### Grant Information
- Funding source details
- Application and approval status
- Disbursement schedules
- Performance requirements

## Getting Started

1. Deploy all five contracts to the Stacks blockchain
2. Initialize the system with regulatory bodies and funding sources
3. Register heritage properties and qualified craftspersons
4. Begin project creation and management
5. Track compliance and funding throughout project lifecycles

## Testing

Run the comprehensive test suite:
\`\`\`bash
npm test
\`\`\`

Tests cover all contract functionality including edge cases and error conditions.

## Configuration

The system uses Clarinet for development and testing. See `Clarinet.toml` for network and contract configuration.
