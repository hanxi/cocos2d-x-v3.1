#include "AppDelegate.h"
#include "CCLuaEngine.h"
#include "SimpleAudioEngine.h"
#include "cocos2d.h"
#include "base/ZipUtils.h"
#include "lua_assetsmanager.h"
#include "lua_util.h"

using namespace CocosDenshion;

USING_NS_CC;
using namespace std;

AppDelegate::AppDelegate()
{
}

AppDelegate::~AppDelegate()
{
    SimpleAudioEngine::end();
}

static void startLua() {
    auto engine = LuaEngine::getInstance();
    ScriptEngineManager::getInstance()->setScriptEngine(engine);

    LuaStack* stack = engine->getLuaStack();
    register_assetsmanager(stack->getLuaState());
    register_util(stack->getLuaState());

    engine->executeScriptFile("src/main.lua");
}

bool AppDelegate::applicationDidFinishLaunching()
{
    ZipUtils::ccSetPvrEncryptionKey(0xdf0ae24f,0xf5ea343a,0xd2cb2384,0xaec1d6d2);

    // initialize director
    auto director = Director::getInstance();
	auto glview = director->getOpenGLView();
	if(!glview) {
		glview = GLView::createWithRect("rutodie", Rect(0,0,320,400));
		director->setOpenGLView(glview);
	}

    glview->setDesignResolutionSize(320, 480, ResolutionPolicy::NO_BORDER);

    // turn on display FPS
    //director->setDisplayStats(true);

    // set FPS. the default value is 1.0/60 if you don't call this
    director->setAnimationInterval(1.0 / 60);

    auto scene = Scene::create();
    auto s = Director::getInstance()->getWinSize();
    auto layer = LayerColor::create(Color4B(255, 255, 255, 255), s.width, s.height);
    auto logo = Sprite::create("res/logo.png");
    layer->addChild(logo);
    logo->setPosition(Vec2(s.width*0.5,s.height*0.7));
    auto actionRotate = RotateBy::create(0.1, 10);
    logo->runAction(RepeatForever::create(actionRotate));
    auto logo2 = Sprite::create("res/hanxi.png");
    layer->addChild(logo2,10);
    logo2->setPosition(Vec2(s.width*0.5,s.height*0.5));
    scene->addChild(layer,0);
    director->runWithScene(scene);

    auto action = CallFunc::create(startLua);
    layer->runAction(action);

    //auto engine = LuaEngine::getInstance();
    //ScriptEngineManager::getInstance()->setScriptEngine(engine);

    //LuaStack* stack = engine->getLuaStack();
    //register_assetsmanager(stack->getLuaState());

    //if (engine->executeScriptFile("src/main.lua")) {
    //    return false;
    //}

    return true;
}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground()
{
    Director::getInstance()->stopAnimation();

    SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    Director::getInstance()->startAnimation();

    SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
}
