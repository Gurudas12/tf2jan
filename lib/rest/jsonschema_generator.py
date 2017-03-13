#!/usr/bin/python
# -*- coding: utf-8 -*-

#import re
import os
import argparse
import string

import json_schema_generator
from json_schema_generator import Recorder, Validator


def record(rest_url, json_schema_file_path):
    """
        The function generates the JSON schema from the json response returned by given REST API

    """
    rec = Recorder.from_url(rest_url)
    rec.save_json_schema(json_schema_file_path, indent=4)
    # To check file is empty or not
    if ( os.stat(json_schema_file_path).st_size == 0 ):
		raise Exception( "REST API %s not returned JSON, file %s is empty " % (rest_url, json_schema_file_path))


def validate(rest_url, json_schema_file_path):
    """
	The function validates the json returned by given REST API using JSON schema

    """
    from urllib2 import urlopen

    json_data = urlopen(rest_url).read()
    validator = Validator.from_path(json_schema_file_path)
    print json_data
    is_valid = validator.assert_json(json_data)

    if is_valid:
        print " Returned JSON is valid"
    else:
        print " Returned JSON is invalid "
        print validator.error_message
	raise Exception( "Returned  JSON is invalid %s" % validator.error_message ) 


def homologate(args):
    template_file_path = os.path.join(os.path.dirname(json_schema_generator.__file__), 'test_template.py.tmpl')
    json_schemas_dir = os.path.join(args.path, 'json_schemas')
    json_schema_file_name = '%s.json_schema' % args.homologation_name
    json_schema_file_path = os.path.join(json_schemas_dir, json_schema_file_name)
    test_file_path = os.path.join(args.path, 'test_%s_json_schema.py' % args.homologation_name)

    with open(template_file_path) as template_file:
        tmpl = string.Template(template_file.read())

    if not os.path.exists(json_schemas_dir):
        os.mkdir(json_schemas_dir)

    if not os.path.exists(json_schema_file_path):
        rec = Recorder.from_url(args.json_source)
        rec.save_json_schema(json_schema_file_path, indent=4)

    rendered = tmpl.substitute(
        homologation_name=args.homologation_name,
        service_url=args.json_source,
        json_schema_file_name=json_schema_file_name,
        json_schemas_dir=json_schemas_dir
    )

    with open(test_file_path, 'w') as test_file:
        test_file.write(rendered)


def main():
    parser = argparse.ArgumentParser()

    default_parser = argparse.ArgumentParser(add_help=False)
    default_parser.add_argument('json_source', type=str, help='url or file')
    default_parser.add_argument('--path', dest='path', default='', help='set path')

    subparsers = parser.add_subparsers(help='sub-command help')

    parser_record = subparsers.add_parser('record', parents=[default_parser])
    parser_record.add_argument('json_schema_file_path', type=str, help='json schema file path')
    parser_record.set_defaults(func=record)

    parser_validate = subparsers.add_parser('validate', parents=[default_parser])
    parser_validate.add_argument('json_schema_file_path', type=str, help='json schema file path')
    parser_validate.set_defaults(func=validate)

    parser_homologate = subparsers.add_parser('homologate', parents=[default_parser])
    parser_homologate.add_argument('homologation_name', type=str, help='json schema file path')
    parser_homologate.set_defaults(func=homologate)

    args = parser.parse_args()
    args.func(args)


if __name__ == '__main__':
    main()

