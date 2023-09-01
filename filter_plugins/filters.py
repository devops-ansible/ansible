#!/usr/bin/env python3

import json
import tomlkit

from tomlkit.items import item
from bs4 import BeautifulSoup
from lxml import etree

class FilterModule(object):

    def filters(self):
        return {
            'to_toml': self.to_toml,
            'from_toml': self.from_toml,
            'text_by_xpath': self.text_by_xpath,
        }

    def to_toml(self, variable, sort_keys=False):
        d = tomlkit.dumps(variable)
        return d

    def from_toml(self, variable):
        d = dict(tomlkit.loads(variable))
        return d

    def text_by_xpath(self, variable, xpath):
        soup = BeautifulSoup(variable, "html.parser")
        dom = etree.HTML(str(soup))
        xpath_result = dom.xpath(xpath)
        return xpath_result
