#Robot to order robots from RobotSpareBin Industries.

import os

from Browser import Browser
from Browser.utils.data_types import SelectAttribute
from RPA.Excel.Files import Files
from RPA.HTTP import HTTP
from RPA.PDF import PDF
from RPA.Browser.Selenium import Selenium


#browser = Browser()

b = Browser(timeout="20 s", retry_assertions_for="500 ms")
def open_website():
    b.new_browser()
    b.new_context(
        acceptDownloads=True,
        viewport={"width": 1920, "height": 1080},
        httpCredentials={"username": "admin", "password": "123456"},
    )
    b.new_page("https://playwright.dev")
    assert b.get_text("h1") == "🎭 Playwright"

#print(dir(browser))

open_website()
