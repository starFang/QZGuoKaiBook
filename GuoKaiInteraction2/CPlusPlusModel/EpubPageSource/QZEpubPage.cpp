//===========================================================================
// Summary:
//     epub中页面中的各种交互对象的定义
// Usage:
//     Null
// Remarks:
//     Null
// Date:
//     2013-09-17
// Author:
//     chenjunfa(chenjunfa@qanzone.com)
//===========================================================================

#include "QZEpubPage.h"
#include <fstream>
#include "QZEpubPageLoadConf.h"

using namespace std;

//构造函数
QZEpubPage::QZEpubPage()
{}

//析构函数
QZEpubPage::~QZEpubPage()
{
	ClearObjectInVector(m_vPosList);
}

const PageBaseElements* QZEpubPage::HitTestElement(QZ_POS pt)
{
	for (vector<PageBaseElements*>::iterator iBegin = m_vPosList.begin();
		iBegin != m_vPosList.end();iBegin++)
	{
		if ((*iBegin)->rect.PosInBox(pt))
		{
			return (*iBegin);
		}
	}

	return QZ_NULL;
}

QZ_ReturnCode QZEpubPage::LoadData(string strPath)
{
	QZEpubPageLoadConf pageLoad;
	pageLoad.Load(strPath.c_str());
	pageLoad.GetPostionList(m_vPosList);
	m_vObjectiveList = pageLoad.GetDrawableObjList();
	m_strContent = pageLoad.GetContentStr();

	return QZR_OK;
}

vector<const PageBaseElements*> QZEpubPage::GetDrawableObjList()
{
	vector<const PageBaseElements*> vResult;
	for (vector<QZ_LONG>::iterator iBegin = m_vObjectiveList.begin();
		iBegin != m_vObjectiveList.end(); iBegin++)
	{
		vResult.push_back(m_vPosList[*iBegin]);
	}

	return vResult;
}

vector<QZ_BOX> QZEpubPage::GetSelectTextRects(BookIndex begin,BookIndex end)
{
	vector<QZ_BOX>  vBoxs;
	
	for (QZ_LONG i = begin.nCharacter ;i < (QZ_LONG)m_vPosList.size() && i < end.nCharacter; i++)
	{
		if (m_vPosList[i]->m_elementType == PAGE_OBJECT_CHARACTER)
		{
			if (vBoxs.empty())
			{
				vBoxs.push_back(m_vPosList[i]->rect);
			}
			else
			{
				QZ_BOX& boxLast = vBoxs.back();
				if (HasVerticalIntersection(boxLast,m_vPosList[i]->rect))
				{
					QZ_DOUBLE space = m_vPosList[i]->rect.X0 - boxLast.X1;
					if (space < boxLast.X1 - boxLast.X0)
					{
						boxLast.X1 = m_vPosList[i]->rect.X1;
						boxLast.Y0 = boxLast.Y0 < m_vPosList[i]->rect.Y0 ? boxLast.Y0 : m_vPosList[i]->rect.Y0;
						boxLast.Y1 = boxLast.Y1 > m_vPosList[i]->rect.Y1 ? boxLast.Y1 : m_vPosList[i]->rect.Y1;
					}
					else
					{
						vBoxs.push_back(m_vPosList[i]->rect);
					}
				}
				else
				{
					vBoxs.push_back(m_vPosList[i]->rect);
				}
			}
		}
	}

	return vBoxs;
}

QZ_BOOL QZEpubPage::HasVerticalIntersection(QZ_BOX rect1,QZ_BOX rect2)
{
	QZ_DOUBLE len = rect1.Y0 + rect1.Y1 - rect2.Y0 - rect2.Y1;
	len = len > 0 ? len : -len;

	QZ_DOUBLE lenTotal = rect1.Y1 - rect1.Y0 + rect2.Y1 - rect2.Y0;

	if (len <= lenTotal)
		return QZ_TRUE;
	else
		return QZ_FALSE;
}
