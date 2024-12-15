-- https://raw.githubusercontent.com/sakaiproject/sakai/master/samigo/docs/auto_submit/auto_submit_mysql.sql

INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL, ENTRY) VALUES (NULL, 1, 'automaticSubmission_isInstructorEditable', 'true');

-- Run these SQL commands to update the templates
CREATE TEMPORARY TABLE UPDATE_SAM_AUTO_IDS AS (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TYPEID='142' AND ISTEMPLATE=1);
-- You may need to clean this up if you've run it multiple times
-- DELETE FROM SAM_ASSESSMETADATA_T WHERE ASSESSMENTID IN (SELECT ID FROM UPDATE_SAM_AUTO_IDS) AND LABEL='automaticSubmission_isInstructorEditable';
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL, ENTRY) SELECT NULL, ID, 'automaticSubmission_isInstructorEditable', 'true' FROM UPDATE_SAM_AUTO_IDS;
DROP TABLE UPDATE_SAM_AUTO_IDS;


-- Run these SQL commands to back fill to your existing assessments
CREATE TEMPORARY TABLE UPDATE_SAM_AUTO_IDS AS (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE ID NOT IN (SELECT ASSESSMENTID FROM SAM_ASSESSMETADATA_T WHERE label = 'automaticSubmission_isInstructorEditable'));
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL, ENTRY) SELECT NULL, ID, 'automaticSubmission_isInstructorEditable', 'true' FROM UPDATE_SAM_AUTO_IDS;
DROP TABLE UPDATE_SAM_AUTO_IDS;

-- Add automatic link to WarpWire nightly
INSERT INTO `lti_tools` (`SITE_ID`, `title`, `allowtitle`, `fa_icon`, `pagetitle`, `allowpagetitle`, `description`, `status`, `visible`, `deployment_id`, `launch`, `allowlaunch`, `consumerkey`, `allowconsumerkey`, `secret`, `allowsecret`, `frameheight`, `toolorder`, `allowframeheight`, `siteinfoconfig`, `sendname`, `sendemailaddr`, `allowoutcomes`, `allowroster`, `pl_launch`, `pl_linkselection`, `pl_contenteditor`, `pl_importitem`, `pl_fileitem`, `pl_assessmentselection`, `newpage`, `debug`, `custom`, `lti13`, `lti13_settings`, `xmlimport`, `splash`, `created_at`, `updated_at`) VALUES
(NULL, 'WarpWire Test Server', 1, NULL, 'WarpWire Test Server', 0, NULL, 0, 0,  NULL, 'https://sakainightly.warpwire.net/api/ltix/?mode=plugin', 1, 'lti:sakainightly:01', 0, 'gsAM:wUeZRn2-kJERm-OkqrKB-nJxdke-webMOj-pj8vL2', 0, NULL, NULL, 0, 0, 1, 1, 1, 1, NULL, 1, 1, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NOW(), NOW());
 
INSERT INTO `lti_tools` (`SITE_ID`, `title`, `allowtitle`, `fa_icon`, `pagetitle`, `allowpagetitle`, `description`, `status`, `visible`, `deployment_id`, `launch`, `allowlaunch`, `consumerkey`, `allowconsumerkey`, `secret`, `allowsecret`, `frameheight`, `toolorder`, `allowframeheight`, `siteinfoconfig`, `sendname`, `sendemailaddr`, `allowoutcomes`, `allowroster`, `pl_launch`, `pl_linkselection`, `pl_contenteditor`, `pl_importitem`, `pl_fileitem`, `pl_assessmentselection`, `newpage`, `debug`, `custom`, `lti13`, `lti13_settings`, `xmlimport`, `splash`, `created_at`, `updated_at`, `pl_lessonsselection`) VALUES
(NULL, 'TsugiCloud App Store', 1, NULL, 'TsugiCloud App Store', 0, NULL, 0, 0,  NULL, 'https://test.tsugicloud.org/tsugi/lti/store/', 1, '12345', 0, 'secret', 0, NULL, NULL, 0, 0, 1, 1, 1, 1, NULL, 1, 1, NULL, NULL, 1, 0, 0, NULL, 0, NULL, NULL, NULL, NOW(), NOW(), 1);
