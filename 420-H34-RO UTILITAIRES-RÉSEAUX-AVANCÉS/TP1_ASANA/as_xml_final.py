#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Nom : Abdul-Bariu Ishola Azeez
# Date : 2025-10 -09
# But : Ce script a pour but d'importer un projet Asana depuis un XML
# afin de créer des projets/taches/sous-tache dans les sections et activités Asana
# Prérequis: Un terminal d'un systeme d'exploitation et Python est ses dépendances installer
# python3 as_xml_tester.py --xml Pratique.xml --workspace 1211590922040040
# ***********************************************************************************************
# ***********************************************************************************************
# ***********************************************************************************************


# Intialistion/Importe des bibilo pour le script
import os
import sys
import argparse
import xml.etree.ElementTree as ET
from typing import Dict, Optional

import asana
from asana.rest import ApiException

try:
    from dotenv import load_dotenv
    load_dotenv()
except Exception:
    pass


# Fonction pour afficher les messages
def info(msg: str) -> None:
    print(f"[INFO] {msg}")

def error(msg: str) -> None:
    print(f"[ERREUR] {msg}")


# Lire les arguments de la ligne de commande
def parse_args():
    p = argparse.ArgumentParser(description="Importer un projet Asana depuis un XML.")
    p.add_argument("--xml", help="Chemin du fichier XML")
    p.add_argument("xml_positional", nargs="?", help="Chemin du fichier XML (positionnel)")
    p.add_argument("--workspace", required=True, help="Workspace GID")
    p.add_argument("--token", help="PAT Asana (déconseillé)")
    return p.parse_args()

# Choisir le fichier XML à utiliser 
# Si --xml est donné, on l'utilise
# Sinon, si xml_positional est donné, on l'utilise
# Sinon, il faut prend Pratique.xml par défaut
def resolve_xml_path(args) -> str:

    return args.xml or args.xml_positional or "Pratique.xml"

#  Créer le client API Asana avec le token 
def get_api_client(token_arg: Optional[str]) -> asana.ApiClient:
    token = (token_arg or "").strip() or os.environ.get("ASANA_PAT", "").strip()
    # Si pas de token demander à l'utilisateur
    if not token:
        import getpass
        token = getpass.getpass("ASANA_PAT: ").strip()
    # Si toujours pas de token, erreur et quitter
    if not token:
        error("Aucun token disponible (ASANA_PAT).")
        sys.exit(1)
    
    # Configurer l'API avec le token
    cfg = asana.Configuration()
    cfg.access_token = token
    api_client = asana.ApiClient(cfg)
    users_api = asana.UsersApi(api_client)
    try:
        user = users_api.get_user("me", opts={'opt_fields': 'gid,email,name'})
        info(f"Token valide: {user['name']} (GID: {user['gid']})")
        info(f"Email: {user['email']}")
    except ApiException as e:
        error(f"Erreur vérification utilisateur: {e}\nBody: {e.body}")
        sys.exit(1)
    return api_client

#  Lire le fichier XML 
def read_xml(xml_path: str) -> Dict:
    # Vérifier si le fichier XML existe et message erreur
    if not os.path.exists(xml_path):
        error(f"Fichier XML introuvable: {xml_path}")
        sys.exit(1)
    try:
        root = ET.parse(xml_path).getroot()
    except ET.ParseError as e:
        error(f"XML invalide: {e}")
        sys.exit(1)
    
    # Vérifier que le XML commence par <PROJET>
    if root.tag != "PROJET":
        error("Le XML doit commencer par <PROJET>.")
        sys.exit(1)
    project_info = {
        "name": (root.attrib.get("Nom") or "").strip(),
        "view": (root.attrib.get("Vue") or "Liste").strip(),
        "description": (root.attrib.get("Description") or "").strip(),
    }
    
    # Extraire les sections et leurs activités
    sections = []
    sp = root.find("SECTIONS")
    if sp is not None:
        for sec in sp.findall("SECTION"):
            sec_name = (sec.attrib.get("Nom") or "").strip()
            acts = []
            ap = sec.find("ACTIVITES")
            if ap is not None:
                for a in ap.findall("ACTIVITE"):
                    acts.append(extract_activity(a))
            sections.append({"name": sec_name, "activities": acts})
    return {"project": project_info, "sections": sections}

#  Extraire une activité du XML ici le nom, description, échéance de l'activité
def extract_activity(el: ET.Element) -> Dict:
    name = (el.findtext("NOM", "") or "").strip() or "Sans nom"
    notes = (el.findtext("DESCRIPTION", "") or "").strip()
    due_raw = (el.findtext("ECHEANCE", "") or el.findtext("DUE_DATE", "") or "").strip()
    subs = []
    sp = el.find("ACTIVITES")
    if sp is not None:
        for se in sp.findall("ACTIVITE"):
            subs.append(extract_activity(se))
    return {"name": name, "notes": notes, "due": due_raw, "subtasks": subs}

#  Convertir la vue en format Asana 
def map_view(view_word: str) -> str:
    v = (view_word or "").lower()
    return "board" if "tableau" in v else "list"

#  Gérer les dates d'échéance 
def split_due_fields(due_raw: str) -> Dict[str, str]:
    # Si pas de date, retourner vide
    if not due_raw:
        return {}
    return {"due_at": due_raw} if "T" in due_raw else {"due_on": due_raw}

#  Vérifier si un projet existe déjà 
def project_exists(projects_api: asana.ProjectsApi, workspace_gid: str, project_name: str) -> Optional[str]:
    opts = {'archived': False, 'limit': 100, 'opt_fields': 'name,gid'}
    try:
        # Lister les projets dans le workspace avec get_projects_for_workspace
        for project in projects_api.get_projects_for_workspace(workspace_gid, opts):
            if project.get("name") == project_name:
                info(f"Projet existant: {project_name} (GID: {project.get('gid')})")
                return project.get("gid")
        return None
    except ApiException as e:
        error(f"Erreur dans la vérife projet: {e}\nBody: {e.body}")
        return None

#  Créer un projet ou récupérer un existant 
def create_project(projects_api: asana.ProjectsApi, workspace_gid: str, project_info: Dict) -> str:
    name = project_info["name"]
    # Si le nom est "?", demander à l'utilisateur
    if name == "?":
        name = input("Entrez le nom du projet (obligatoire, ? non valide): ").strip()
        if not name:
            error("Nom du projet requis.")
            sys.exit(1)
    # Préparer les données du projet
    body = {
        "data": {
            "name": name or "Projet sans nom",
            "default_view": map_view(project_info["view"]),
            "is_template": False,
            "description": project_info["description"],
            "workspace": workspace_gid,
        }
    }
    try:
        # Créer le projet via l'API
        response = projects_api.create_project(body, opts={'opt_fields': 'gid,name'})
        project_data = response.get("data", response)
        if not project_data or "gid" not in project_data:
            error(f"Erreur création projet: réponse inattendue\nBody: {response}")
            raise ValueError("Réponse API sans 'gid'")
        info(f"Projet créé: {project_data['name']} (GID: {project_data['gid']})")
        return project_data["gid"]
    except ApiException as e:
        error(f"Erreur création projet: {e}\nBody: {e.body}")
        raise

#  Vérifier si une section existe 
def get_section_by_name(sections_api: asana.SectionsApi, project_gid: str, section_name: str) -> Optional[Dict]:
    try:
        sections = sections_api.get_sections_for_project(project_gid, {"limit": 100, "opt_fields": "name,gid"})
        for s in sections:
            if s.get("name") == section_name:
                return s
        return None
    except ApiException as e:
        error(f"Erreur récupération sections: {e}\nBody: {e.body}")
        return None

#  Créer une section ou récupérer une existante 
def create_section(sections_api: asana.SectionsApi, project_gid: str, section_name: str) -> Dict:
    name = section_name.strip()
    # Si le nom est vide ou "?", demander à l'utilisateur
    if not name or name == "?":
        name = input("Entrez le nom de la section (obligatoire, ? non valide): ").strip()
        if not name:
            error("Nom de la section requis.")
            sys.exit(1)
    # Vérifier si la section existe déjà
    existing = get_section_by_name(sections_api, project_gid, name)
    if existing:
        info(f"Section existante: {name} (GID: {existing['gid']})")
        return existing
    try:
        # Créer une nouvelle section
        body = {"data": {"name": name}}
        section = sections_api.create_section_for_project(project_gid, opts={"body": body, '_request_timeout': (10, 30)})
        info(f"Section créée: {name} (GID: {section['gid']})")
        return section
    except ApiException as e:
        error(f"Erreur création section: {e}\nBody: {e.body}")
        raise

#  Lister les noms des tâches dans une section 
def get_task_names_in_section(tasks_api: asana.TasksApi, project_gid: str, section_gid: str) -> set:
    task_names = set()
    # Essayer d'abord avec une requête par section
    params = {"section": section_gid, "limit": 100, "opt_fields": "name,gid"}
    try:
        for response in tasks_api.get_tasks(params, _request_timeout=(10, 30)):
            tasks = response.get("data", [])
            for task in tasks:
                task_name = task.get("name")
                if task_name:
                    task_names.add(task_name)
                    info(f"Found task (section query): {task_name} (GID: {task.get('gid')}) in section {section_gid}")
        if task_names:
            info(f"Retrieved {len(task_names)} task names for section {section_gid} (section query)")
            return task_names
    except ApiException as e:
        error(f"Erreur récupération tâches (section query) section {section_gid}: {e}\nBody: {e.body}")
    
    # Si échec, essayer avec une requête par projet
    task_names = set()
    params = {"project": project_gid, "limit": 100, "opt_fields": "name,gid,memberships.section"}
    try:
        for response in tasks_api.get_tasks(params, _request_timeout=(10, 30)):
            tasks = response.get("data", [])
            for task in tasks:
                memberships = task.get("memberships", [])
                for membership in memberships:
                    if membership.get("section", {}).get("gid") == section_gid:
                        task_name = task.get("name")
                        if task_name:
                            task_names.add(task_name)
                            info(f"Found task (project query): {task_name} (GID: {task.get('gid')}) in section {section_gid}")
        info(f"Retrieved {len(task_names)} task names for section {section_gid} (project query)")
        return task_names
    except ApiException as e:
        error(f"Erreur récupération tâches (project query) section {section_gid}: {e}\nBody: {e.body}")
        return set()

#  Créer une tâche dans une section 
def create_task_in_section(tasks_api: asana.TasksApi, sections_api: asana.SectionsApi, project_gid: str, section_gid: str, activity: Dict) -> Dict:
    name = activity["name"] or "Sans nom"
    # Vérifier si la tâche existe déjà
    existing_names = get_task_names_in_section(tasks_api, project_gid, section_gid)
    if name in existing_names:
        info(f"Tâche existante: {name}")
        return {"gid": None}
    # Préparer les données de la tâche
    body = {
        "data": {
            "name": name,
            "projects": [project_gid],
            "memberships": [{"project": project_gid, "section": section_gid}],
            "notes": activity["notes"],
            **split_due_fields(activity["due"]),
        }
    }
    try:
        # Créer la tâche via l'API
        task_obj = tasks_api.create_task(body, opts={'opt_fields': 'gid,name'})
        info(f"Tâche créée: {name} (GID: {task_obj['gid']})")
        return task_obj
    except ApiException as e:
        error(f"Erreur création tâche: {e}\nBody: {e.body}")
        return {"gid": None}

#  Créer une sous-tâche 
def create_subtask(tasks_api: asana.TasksApi, parent_task_gid: str, subtask: Dict) -> None:
    name = subtask["name"] or "Sous-tâche sans nom"
    # Préparer les données de la sous-tâche
    body = {
        "data": {
            "name": name,
            "notes": subtask["notes"],
            **split_due_fields(subtask["due"]),
        }
    }
    try:
        # Créer la sous-tâche via l'API
        subtask_obj = tasks_api.create_subtask_for_task(body, parent_task_gid, opts={'opt_fields': 'gid,name'})
        info(f"Sous-tâche créée: {name} (GID: {subtask_obj['gid']})")
    except ApiException as e:
        error(f"Erreur création sous-tâche: {e}\nBody: {e.body}")

#  Créer l'arbre de tâches et sous-tâches 
def create_task_tree(tasks_api: asana.TasksApi, sections_api: asana.SectionsApi, project_gid: str, section_gid: str, activity: Dict) -> None:
    # Créer la tâche principale
    task_obj = create_task_in_section(tasks_api, sections_api, project_gid, section_gid, activity)
    if task_obj.get("gid") and activity.get("subtasks"):
        for subtask in activity["subtasks"]:
            create_subtask(tasks_api, task_obj["gid"], subtask)

#  Supprimer la section par défaut "Untitled Section" 
def delete_default_section(sections_api: asana.SectionsApi, project_gid: str) -> None:
    try:
        sections = sections_api.get_sections_for_project(project_gid, {"limit": 100, "opt_fields": "name,gid"})
        for s in sections:
            if s.get("name") == "Untitled Section":
                try:
                    sections_api.delete_section(s["gid"])
                    info(f"Section par défaut supprimée: {s['gid']}")
                except ApiException as e:
                    error(f"Impossible de supprimer section par défaut: {e}")
    except ApiException as e:
        error(f"Erreur vérification sections par défaut: {e}")

#  Fonction principale 
def main():
    args = parse_args()
    xml_path = resolve_xml_path(args)
    workspace_gid = args.workspace
    info(f"Workspace GID fourni: {workspace_gid}")
    
    # Créer le client API
    api_client = get_api_client(args.token)
    projects_api = asana.ProjectsApi(api_client)
    sections_api = asana.SectionsApi(api_client)
    tasks_api = asana.TasksApi(api_client)

    xml_data = read_xml(xml_path)
    project_info = xml_data["project"]
    project_name = project_info["name"]

    project_gid = project_exists(projects_api, workspace_gid, project_name)
    if not project_gid:
        info(f"Création du projet: {project_name if project_name != '?' else 'à définir'}")
        project_gid = create_project(projects_api, workspace_gid, project_info)
    else:
        info(f"Projet prêt: {project_name} (gid={project_gid})")
    
    # Si la vue est "list", supprimer la section par défaut
    if map_view(project_info["view"]) == "list":
        delete_default_section(sections_api, project_gid)
    for section in xml_data["sections"]:
        section_obj = create_section(sections_api, project_gid, section["name"])
        for act in section["activities"]:
            create_task_tree(tasks_api, sections_api, project_gid, section_obj.get("gid"), act)
    info("Le script est executez. Vérifiez SVP confirmer votre projet dans Asana.")

# Lancer le script
if __name__ == "__main__":
    try:
        main()
    except ApiException as e:
        error(f"Erreur Asana (API): {e}")
        sys.exit(1)
    except KeyboardInterrupt:
        error("Interrompu par l'utilisateur.")
        sys.exit(1)